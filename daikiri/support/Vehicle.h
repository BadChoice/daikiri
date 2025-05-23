//
//  ExampleArray.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daikiri.h"

@interface Vehicle : Daikiri

@property (strong,nonatomic) NSString* model;
@property (strong,nonatomic) NSNumber* isCool;
@property (strong,nonatomic) NSArray* nicknames;
@property (strong,nonatomic) NSDictionary* rules;

@end
