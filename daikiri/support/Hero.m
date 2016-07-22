//
//  ExampleModel.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "Hero.h"

@implementation Hero

-(NSArray*)friends{
    return [self hasMany:@"Friend" foreignKey:@"hero_id" sort:@"id"];
}

-(NSArray*)enemies{
    return [self belongsToMany:@"Enemy" pivot:@"EnemyHero" localKey:@"hero_id" foreignKey:@"enemy_id"];
}

/*-(NSArray*)toDictionaryIgnore{
    return @[@"headquarter"];
}*/
@end
