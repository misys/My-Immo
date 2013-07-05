//
//  MIAddLeaseHolderActivity.m
//  My Immo
//
//  Created by Olivier Michiels on 05/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import "MIAddLeaseHolderActivity.h"

@implementation MIAddLeaseHolderActivity
@synthesize delegate = _delegate;

-(NSString*)activityType {
    return NSStringFromClass([self class]);
}

-(NSString*)activityTitle {
    return @"Add Lease holder";
}

-(UIImage*)activityImage {
    return [UIImage imageNamed:@"Safari"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
}

- (void)performActivity
{
	[self.delegate addLeaseHolder];
}


@end
