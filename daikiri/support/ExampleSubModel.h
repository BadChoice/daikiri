//
//  ExampleSubModel.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daikiri.h"

@interface ExampleSubModel : Daikiri

@property(strong,nonatomic) NSNumber* id;
@property(strong,nonatomic) NSString* address;
@property(strong,nonatomic) NSNumber* isValid;
@property(strong,nonatomic) NSArray*  anArray;

@end
