//
//  ExampleArray.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daikiri.h"

@class Driver;
@interface Vehicle : Daikiri

@property (strong,nonatomic) NSString* _Nonnull model;
@property (strong,nonatomic) NSNumber* _Nonnull isCool;
@property (strong,nonatomic) NSArray* _Nonnull nicknames;
@property (strong,nonatomic) NSDictionary* _Nullable rules;
@property (strong,nonatomic) NSArray<Driver*>* _Nullable drivers;

@end
