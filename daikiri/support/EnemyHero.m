//
//  Enemy_Hero.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 17/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "EnemyHero.h"

@implementation EnemyHero

-(Enemy*)enemy{
    return (Enemy*)[self belongsTo:@"Enemy" localKey:@"enemy_id"];
}
-(Hero*)hero{
    return (Hero*)[self belongsTo:@"Hero" localKey:@"hero_id"];
}
@end
