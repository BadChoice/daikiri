//
//  ExampleModel.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daikiri.h"
#import "Headquarter.h"

@interface Hero : Daikiri

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* age;
@property (strong,nonatomic) Headquarter* headquarter;

-(NSArray*)friends;
@end
