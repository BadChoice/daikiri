//
//  ExampleModel.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "Hero.h"
#import "Tag.h"

@implementation Hero

-(NSArray*)friends{
    return [self hasMany:@"Friend" foreignKey:@"hero_id" sort:@"id"];
}

-(NSArray*)enemies{
    return [self belongsToMany:@"Enemy" pivot:@"EnemyHero" localKey:@"hero_id" foreignKey:@"enemy_id"];
}

-(NSArray*)tags{
    return [self morphMany:@"Tag" typeKey:@"taggable_type" idKey:@"taggable_id" sort:@"id"];
}

/*-(NSArray*)toDictionaryIgnore{
    return @[@"headquarter"];
}*/
@end
