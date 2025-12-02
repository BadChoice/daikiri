//
//  Tag.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 29/2/24.
//  Copyright © 2024 revo. All rights reserved.
//

#import "Tag.h"
#import "Taggable.h"
#import "RVCollection.h"
#import "Hero.h"
#import "Enemy.h"

@implementation Tag

-(id)taggable{
    return [self morphTo:@"taggable"];
}

-(NSArray*)heroes{
    return [self morphedByMany:@"Hero" relationship:@"taggable" localKey:@"tag_id" pivotModel:@"Taggable"];
}

-(NSArray*)enemies{
    return [self morphedByMany:@"Enemy" relationship:@"taggable" localKey:@"tag_id" pivotModel:@"Taggable"];
}
@end
