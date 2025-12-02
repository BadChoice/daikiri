//
//  Tag.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 29/2/24.
//  Copyright © 2024 revo. All rights reserved.
//

#import "Taggable.h"

@implementation Taggable

-(Tag*)tag{
    return (Tag*)[self belongsTo:@"Tag" localKey:@"tag_id"];
}

-(id)taggable{
    return [self morphTo:@"taggable"];
}

@end
