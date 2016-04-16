//
//  ExampleModel.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daikiri.h"
#import "ExampleSubModel.h"

@interface ExampleModel : Daikiri

@property (strong,nonatomic) NSNumber* id;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* age;
@property (strong,nonatomic) ExampleSubModel* submodel;

@end
