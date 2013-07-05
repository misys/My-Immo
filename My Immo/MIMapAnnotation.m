//
//  MIMapAnnotation.m
//  My Immo
//
//  Created by Olivier Michiels on 03/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import "MIMapAnnotation.h"
#import <AddressBook/AddressBook.h>
#import "MIGood.h"
#import "MILeaseHolder.h"

@implementation MIMapAnnotation
@synthesize good = _good;
@synthesize coordinate = _coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    
    return self;
}

-(MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:@{(NSString*)kABPersonAddressStreetKey : self.good.address}];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = @"Good";
    
    return mapItem;
}

-(NSString*)title {
    if (self.good.leaseHolder) return [NSString stringWithFormat:@"Good rent to %@", self.good.leaseHolder.name];
    else return @"Good";
}

-(NSString*)subtitle {
    return self.good.address;
}
@end
