//
//  MIAddGoodActivity.h
//  My Immo
//
//  Created by Olivier Michiels on 03/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIAddGoodActivityDelegate;
@interface MIAddGoodActivity : UIActivity
@property(nonatomic, assign) id<MIAddGoodActivityDelegate> delegate;
@end

@protocol MIAddGoodActivityDelegate <NSObject>

-(void)addGood;

@end
