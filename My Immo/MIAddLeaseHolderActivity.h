//
//  MIAddLeaseHolderActivity.h
//  My Immo
//
//  Created by Olivier Michiels on 05/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIAddLeaseHolderActivityDelegate;
@interface MIAddLeaseHolderActivity : UIActivity
@property(nonatomic, assign) id<MIAddLeaseHolderActivityDelegate> delegate;
@end

@protocol MIAddLeaseHolderActivityDelegate <NSObject>

-(void)addLeaseHolder;

@end
