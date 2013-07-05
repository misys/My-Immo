//
//  MIViewController.m
//  My Immo
//
//  Created by Olivier Michiels on 03/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import "MIViewController.h"
#import "MIAddGoodActivity.h"
#import "MIAddGoodViewController.h"
#import <MapKit/MapKit.h>
#import "MIMapAnnotation.h"
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@interface MIViewController () <UIPopoverControllerDelegate, MIAddGoodActivityDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionItem;
@property (nonatomic, strong) UINavigationController *nav;
@property(nonatomic, strong) UIPopoverController *popover;
@property(nonatomic, strong) NSMutableArray *goodAdresses;
@property (weak, nonatomic) IBOutlet UIView *addGoodView;
@property (weak, nonatomic) IBOutlet UITextField *addGoodAddress;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.goodAdresses = [[NSMutableArray alloc] init];
    self.mapView.showsUserLocation = YES;
    
    self.addGoodView.layer.masksToBounds = NO;
    self.addGoodView.layer.cornerRadius = 5.;
    self.addGoodView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addGoodView.layer.shadowOffset = CGSizeMake(1, 1);
    self.addGoodView.layer.shadowOpacity = .75;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    if (self.popover && self.popover.isPopoverVisible) return;
    
    MIAddGoodActivity *addGoodActivity = [[MIAddGoodActivity alloc] init];
    addGoodActivity.delegate = self;
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[[[UIImage alloc] init]] applicationActivities:@[addGoodActivity]];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
    self.popover.delegate = self;
    [self.popover presentPopoverFromBarButtonItem:self.actionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


-(void)addGood {
   [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
 /*
    MIAddGoodViewController *vc = [[MIAddGoodViewController alloc] initWithNibName:@"AddGoodViewController_iPad" bundle:nil];
    vc.delegate = self;
    self.nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.nav.modalPresentationStyle = UIModalPresentationFormSheet;
    self.nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.nav animated:YES completion:nil];
    self.nav.view.superview.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
    self.nav.view.superview.center = self.view.center;*/
    self.addGoodView.hidden = NO;
}
/*
-(void)goodAdded:(NSString*)goodAddress {
    [self.nav dismissViewControllerAnimated:YES completion:nil];
    self.nav = nil;
    [self.goodAdresses addObject:goodAddress];
    [self refreshMap];
}

-(void)addGoodViewControllerDidCancel:(MIAddGoodViewController *)addGoodViewController {
    [self.nav dismissViewControllerAnimated:YES completion:nil];
    self.nav = nil;
}
*/

- (IBAction)addGood:(id)sender {
    [self.goodAdresses addObject:self.addGoodAddress.text];
    [self refreshMap];
}

- (IBAction)AddGoodCancelled:(id)sender {
    self.addGoodView.hidden = YES;
}

-(void)refreshMap {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:self.goodAdresses.count];
    [self.mapView removeAnnotations:self.mapView.annotations];
    CLLocationCoordinate2D coord;
    for (NSString *address in self.goodAdresses) {
        coord = [self getLocationFromAddressString:address];
        if (coord.latitude > 0. && coord.longitude > 0.) {
            MIMapAnnotation *annotation = [[MIMapAnnotation alloc] initWithCoordinate:coord];
            annotation.address = address;
            [annotations addObject:annotation];
        }
    }
    
    if (annotations.count > 0) {
        coord = ((MIMapAnnotation*)[annotations lastObject]).coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [self.mapView setRegion:viewRegion animated:YES];
        [self.mapView selectAnnotation:[annotations lastObject] animated:YES];
    }
    [self.mapView addAnnotations:annotations];
}

-(CLLocationCoordinate2D)getLocationFromAddressString:(NSString*) addressStr {
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false",
                        [addressStr stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:NULL];

    NSError *_error = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[locationStr dataUsingEncoding:NSUTF8StringEncoding]
                          options:kNilOptions
                          error:&_error];
    double lat = 0.0;
    double lon = 0.0;
    
    CLLocationCoordinate2D location;
    location.latitude = lat;
    location.longitude = lon;
    
    if(json) {
        NSString *status = [json valueForKey:@"status"];
        if ([@"OK" isEqualToString:status]) {
            NSArray *results = [json objectForKey:@"results"];
            NSDictionary *geometry = [[results objectAtIndex:0] objectForKey:@"geometry"];
            NSDictionary *loc = [geometry objectForKey:@"location"];
            location.latitude = [[loc valueForKey:@"lat"] doubleValue];
            location.longitude = [[loc valueForKey:@"lng"] doubleValue];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Address, %@ not found", addressStr] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Address, %@ not found", addressStr] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

    
    return location;
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MIMapAnnotation class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutTapped:)];
            [annotationView addGestureRecognizer:tapGesture];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)calloutTapped:(id)sender {

}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:CGRectMake(10, 10, 100, 100) inView:self.view];
    
    UIMenuItem *menuItemDelete = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(delete:)];
    UIMenuItem *menuItemModify = [[UIMenuItem alloc] initWithTitle:@"Modify" action:@selector(modify:)];
    menuController.menuItems = @[menuItemDelete, menuItemModify];
    menuController.arrowDirection = UIMenuControllerArrowDown;
    [menuController setMenuVisible:YES animated:YES];
}
@end
