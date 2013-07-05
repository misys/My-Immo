//
//  MIAddGoodViewController.h
//  My Immo
//
//  Created by Olivier Michiels on 03/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIAddGoodViewControllerDelegate;
@interface MIAddGoodViewController : UIViewController
@property(nonatomic, assign) id<MIAddGoodViewControllerDelegate> delegate;
@end

@protocol MIAddGoodViewControllerDelegate <NSObject>

-(void)goodAdded:(NSString*)goodAddress;
-(void)addGoodViewControllerDidCancel:(MIAddGoodViewController*)addGoodViewController;
@end
