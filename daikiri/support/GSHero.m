//
//  GSHero.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 19/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "GSHero.h"

@implementation GSHero

+(BOOL)usesPrefix{
    return true;
}

-(NSArray*)friends{
    return [self hasMany:@"Friend" foreignKey:@"hero_id"];
}

-(NSArray*)enemies{
    return [self belongsToMany:@"GSEnemy" pivot:@"GSEnemyHero" localKey:@"hero_id" foreignKey:@"enemy_id"];
}
@end
