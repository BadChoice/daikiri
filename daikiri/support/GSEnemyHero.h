//
//  GSEnemyHero.h
//  daikiri
//
//  Created by Badchoice on 20/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "Daikiri.h"
#import "GSHero.h"
#import "GSEnemy.h"

@interface GSEnemyHero : Daikiri

@property (strong,nonatomic) NSNumber* hero_id;
@property (strong,nonatomic) NSNumber* enemy_id;
@property (strong,nonatomic) NSNumber* level;

-(GSEnemy*)enemy;
-(GSHero*)hero;
@end
