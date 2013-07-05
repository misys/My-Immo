//
//  MIGood.h
//  My Immo
//
//  Created by Olivier Michiels on 05/07/13.
//  Copyright (c) 2013 Olivier Michiels. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MILeaseHolder;
@interface MIGood : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, getter = isRent) BOOL rent;
@property (nonatomic, strong) MILeaseHolder *leaseHolder;
@end
