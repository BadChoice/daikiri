//
//  ExampleSubModel.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daikiri.h"

@interface Headquarter : Daikiri

@property(strong,nonatomic) NSString* address;
@property(strong,nonatomic) NSNumber* isActive;
@property(strong,nonatomic) NSArray*  vehicles;

@end
