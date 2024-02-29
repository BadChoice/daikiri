//
//  Tag.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 29/2/24.
//  Copyright © 2024 revo. All rights reserved.
//

#import "Tag.h"

@implementation Tag

-(id)taggable{
    return [self morphTo:@"taggable"];
}

@end
