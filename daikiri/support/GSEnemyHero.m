//
//  GSEnemyHero.m
//  daikiri
//
//  Created by Badchoice on 20/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "GSEnemyHero.h"


@implementation GSEnemyHero
+(BOOL)usesPrefix{
    return true;
}

-(GSEnemy*)enemy{
    return (GSEnemy*)[self belongsTo:@"GSEnemy" localKey:@"enemy_id"];
}
-(GSHero*)hero{
    return (GSHero*)[self belongsTo:@"GSHero" localKey:@"hero_id"];
}

@end
