//
//  MIViewController.m
//  My Immo
//
//  Created by Olivier Michiels on 03/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import "MIViewController.h"
#import "MIAddGoodActivity.h"
#import "MIAddLeaseHolderActivity.h"
#import <MapKit/MapKit.h>
#import "MIMapAnnotation.h"
#import <QuartzCore/QuartzCore.h>
#import "MIAddGoodView.h"
#import "QBPopupMenu.h"
#import "MIGood.h"
#import "MILeaseHolder.h"

#define METERS_PER_MILE 1609.344

@interface MIViewController () <UIPopoverControllerDelegate, MIAddGoodActivityDelegate, MIAddLeaseHolderActivityDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    SEL actionSelector;
    NSInteger selectedLeaseHolder;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionItem;
@property (nonatomic, strong) UINavigationController *nav;
@property(nonatomic, strong) UIPopoverController *popover;
@property(nonatomic, strong) NSMutableArray *leaseHolders;
@property(nonatomic, strong) NSMutableArray *goods;
@property (weak, nonatomic) IBOutlet MIAddGoodView *addGoodView;
@property (weak, nonatomic) IBOutlet UITextField *addGoodAddress;
@property (weak, nonatomic) IBOutlet UITextField *editGoodAddress;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *editGoodView;
@property (weak, nonatomic) IBOutlet UIView *alertMessageView;
@property (weak, nonatomic) IBOutlet UILabel *alertMessageTitle;
@property (weak, nonatomic) IBOutlet UILabel *alertMessage;
@property (nonatomic, strong) MIMapAnnotation *selectedAnnotation;
@property (weak, nonatomic) IBOutlet UIView *rentGoodView;
@property (weak, nonatomic) IBOutlet UITableView *rentGoodTableView;
@property (weak, nonatomic) IBOutlet UIView *addLeaseHolderView;
@property (weak, nonatomic) IBOutlet UITextField *leaseHolderName;
@property (weak, nonatomic) IBOutlet UIButton *rentGoodDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *addGoodButton;
@property (weak, nonatomic) IBOutlet UIButton *addLeaseHolderButton;
@end

@implementation MIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.leaseHolders = [[NSMutableArray alloc] init];
    self.goods = [[NSMutableArray alloc] init];
    self.mapView.showsUserLocation = YES;
    
    self.addGoodView.layer.masksToBounds = NO;
    self.addGoodView.layer.cornerRadius = 5.;
    self.addGoodView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addGoodView.layer.shadowOffset = CGSizeMake(1, 1);
    self.addGoodView.layer.shadowOpacity = .75;
    
    self.editGoodView.layer.masksToBounds = NO;
    self.editGoodView.layer.cornerRadius = 5.;
    self.editGoodView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.editGoodView.layer.shadowOffset = CGSizeMake(1, 1);
    self.editGoodView.layer.shadowOpacity = .75;
    
    self.alertMessageView.layer.masksToBounds = NO;
    self.alertMessageView.layer.cornerRadius = 5.;
    self.alertMessageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertMessageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.alertMessageView.layer.shadowOpacity = .75;
    
    self.rentGoodView.layer.masksToBounds = NO;
    self.rentGoodView.layer.cornerRadius = 5.;
    self.rentGoodView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.rentGoodView.layer.shadowOffset = CGSizeMake(1, 1);
    self.rentGoodView.layer.shadowOpacity = .75;
    
    self.addLeaseHolderView.layer.masksToBounds = NO;
    self.addLeaseHolderView.layer.cornerRadius = 5.;
    self.addLeaseHolderView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addLeaseHolderView.layer.shadowOffset = CGSizeMake(1, 1);
    self.addLeaseHolderView.layer.shadowOpacity = .75;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    if (self.popover && self.popover.isPopoverVisible) return;
    
    MIAddGoodActivity *addGoodActivity = [[MIAddGoodActivity alloc] init];
    MIAddLeaseHolderActivity *addLeaseHolderActivity = [[MIAddLeaseHolderActivity alloc] init];
    
    addGoodActivity.delegate = self;
    addLeaseHolderActivity.delegate = self;
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[[[UIImage alloc] init]] applicationActivities:@[addGoodActivity, addLeaseHolderActivity]];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
    self.popover.delegate = self;
    [self.popover presentPopoverFromBarButtonItem:self.actionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


-(void)addGood {
   [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    
//    self.addGoodButton.enabled = NO;
    [self animateShow:self.addGoodView];
}

-(void)addLeaseHolder {
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    
//    self.addLeaseHolderButton.enabled = NO;
    [self animateShow:self.addLeaseHolderView];
}

- (void)animateShow:(UIView*)view
{
    view.hidden = NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.1;
    
    [view.layer addAnimation:animation forKey:@"show"];
}

- (void)animateHide:(UIView*)view
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.0, 0.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.1;
    
    [view.layer addAnimation:animation forKey:@"hide"];
    
    [self performSelector:@selector(hideView:) withObject:view afterDelay:0.105];
}

-(void)hideView:(id)object {
    UIView *v = (UIView*)object;
    v.hidden = YES;
}

#pragma mark -

#pragma mark add good
- (IBAction)addGood:(id)sender {
    [self.addGoodAddress resignFirstResponder];
    [self animateHide:self.addGoodView];
    MIGood *good = [[MIGood alloc] init];
    good.address = self.addGoodAddress.text;
    [self.goods addObject:good];

    [self refreshMap];
}

- (IBAction)AddGoodCancelled:(id)sender {
    [self animateHide:self.addGoodView];
}

#pragma mark -

#pragma mark edit good
- (IBAction)editGoodDone:(id)sender {
    [self.editGoodAddress resignFirstResponder];
    [self animateHide:self.editGoodView];
    [self.goods removeObject:self.selectedAnnotation.good];
    [self.goods addObject:self.selectedAnnotation.good];
    self.selectedAnnotation = nil;
    [self refreshMap];
}

- (IBAction)editGoodCancelled:(id)sender {
    [self animateHide:self.editGoodView];
}

#pragma mark -

#pragma mark alert message
- (IBAction)alertMessageCancelled:(id)sender {
    [self animateHide:self.alertMessageView];
}

- (IBAction)alertMessageOk:(id)sender {
    [self animateHide:self.alertMessageView];
    [self performSelector:actionSelector];
}

#pragma mark -

#pragma mark rent good
- (IBAction)rentGoodDone:(id)sender {
    [self animateHide:self.rentGoodView];
    if (self.selectedAnnotation) {
        self.selectedAnnotation.good.rent = YES;
        self.selectedAnnotation.good.leaseHolder = [self.leaseHolders objectAtIndex:selectedLeaseHolder];
        selectedLeaseHolder = -1;
        [self.goods removeObject:self.selectedAnnotation.good];
        [self.goods addObject:self.selectedAnnotation.good];
        self.selectedAnnotation = nil;
        [self refreshMap];
    }
}

- (IBAction)rentGoodCancelled:(id)sender {
    [self animateHide:self.rentGoodView];
}

- (IBAction)addLeaseHolder:(id)sender {
    MILeaseHolder *leaseHolder = [[MILeaseHolder alloc] init];
    leaseHolder.name = self.leaseHolderName.text;
    [self.leaseHolders addObject:leaseHolder];
    [self hideView:self.addLeaseHolderView];
}

- (IBAction)addLeaseHolderCancelled:(id)sender {
    [self hideView:self.addLeaseHolderView];
}

-(void)refreshMap {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:self.goods.count];
    [self.mapView removeAnnotations:self.mapView.annotations];
    CLLocationCoordinate2D coord;
    for (MIGood *good in self.goods) {
        coord = [self getLocationFromAddressString:good.address];
        if (coord.latitude > 0. && coord.longitude > 0.) {
            MIMapAnnotation *annotation = [[MIMapAnnotation alloc] initWithCoordinate:coord];
            annotation.good = good;
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
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            ((MKPinAnnotationView*)annotationView).animatesDrop = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutTapped:)];
            [annotationView addGestureRecognizer:tapGesture];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.pinColor = ((MIMapAnnotation*)annotation).good.isRent ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
        
        return annotationView;
    }
    
    return nil;
}

-(void)calloutTapped:(id)sender {

}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    self.selectedAnnotation = view.annotation;
    QBPopupMenu *menu = [[QBPopupMenu alloc] init];
    menu.alpha = .8;
    QBPopupMenuItem *deleteItem = [[QBPopupMenuItem alloc] initWithTitle:@"Delete" target:self action:@selector(deleteGood:)];
    QBPopupMenuItem *editItem = [[QBPopupMenuItem alloc] initWithTitle:@"Edit" target:self action:@selector(editGood:)];
    QBPopupMenuItem *rentItem = 
    ((MIMapAnnotation*)view.annotation).good.isRent ? [[QBPopupMenuItem alloc] initWithTitle:@"Unrent it" target:self action:@selector(unrentGood:)] : [[QBPopupMenuItem alloc] initWithTitle:@"Rent it" target:self action:@selector(rentGood:)];
    menu.items = @[deleteItem, editItem, rentItem];
    [self.mapView deselectAnnotation:view.annotation animated:YES];
    CGPoint point = [self.mapView convertCoordinate:view.annotation.coordinate toPointToView:self.view];
    point.y = point.y - 35;
    [menu showInView:self.view atPoint:point];
}

-(void)deleteGood:(id)sender {
    if (self.selectedAnnotation) {
        actionSelector = @selector(okToDelete);
        self.alertMessageTitle.text = @"Attention!";
        self.alertMessage.text = @"Delete this good?";
        [self animateShow:self.alertMessageView];
    }
}

-(void)editGood:(id)sender {
    if (self.selectedAnnotation) {
        self.editGoodAddress.text = self.selectedAnnotation.good.address;
        [self animateShow:self.editGoodView];
    }
}

-(void)rentGood:(id)sender {
    if (self.selectedAnnotation) {
        [self.rentGoodTableView reloadData];
        self.rentGoodDoneButton.enabled = NO;
        [self animateShow:self.rentGoodView];
    }
}

-(void)unrentGood:(id)sender {
    if (self.selectedAnnotation) {
        self.selectedAnnotation.good.rent = NO;
        self.selectedAnnotation.good.leaseHolder = nil;
        [self.goods removeObject:self.selectedAnnotation.good];
        [self.goods addObject:self.selectedAnnotation.good];
        self.selectedAnnotation = nil;
        [self refreshMap];
    }
}

-(void)okToDelete {
    [self.goods removeObject:self.selectedAnnotation.good];
    self.selectedAnnotation = nil;
    [self refreshMap];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leaseHolders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = ((MILeaseHolder*)[self.leaseHolders objectAtIndex:indexPath.row]).name;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.rentGoodDoneButton.enabled = YES;
    selectedLeaseHolder = indexPath.row;
}
@end
