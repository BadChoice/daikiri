//
//  HeroFactory.m
//  daikiri
//
//  Created by Badchoice on 22/11/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "HeroFactory.h"
#import "Hero.h"
#import "Enemy.h"

@implementation HeroFactory

+(void)registerFactories{
    
    [DKFactory define:Hero.class builder:^NSDictionary *{
        return @{
                 @"id"  : @1,
                 @"name": @"Batman",
                 @"age" : @"49"
             };
    }];
    
    [DKFactory define:Enemy.class builder:^NSDictionary *{
        return @{
                 @"id"  : @1,
                 @"name": @"Luxor",
                 @"age" : @"32"
                 };
    }];
    
}
@end
