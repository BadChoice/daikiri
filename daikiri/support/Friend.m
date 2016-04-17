//
//  Friend.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 17/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "Friend.h"

@implementation Friend


-(Hero*)hero{
    return (Hero*)[self belongsTo:@"Hero" localKey:@"hero_id"];
}

@end
