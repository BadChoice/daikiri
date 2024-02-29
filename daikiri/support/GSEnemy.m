//
//  GSEnemy.m
//  daikiri
//
//  Created by Badchoice on 20/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "GSEnemy.h"

@implementation GSEnemy

+(BOOL)usesPrefix{
    return true;
}

-(NSArray*)tags{
    return [self morphMany:@"Tag" relationship:@"taggable" sort:@"id"];
}

@end
