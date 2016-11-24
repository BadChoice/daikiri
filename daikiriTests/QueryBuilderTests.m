//
//  QueryBuilderTests.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 22/7/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Hero.h"
#import "Enemy.h"
#import "Friend.h"
#import "EnemyHero.h"
#import "GSHero.h"
#import "DaikiriCoreData.h"

#import "HeroFactory.h"

@interface QueryBuilderTests : XCTestCase

@end

@implementation QueryBuilderTests

- (void)setUp {
    [super setUp];
    
    [HeroFactory registerFactories];
    [[DaikiriCoreData manager] useTestDatabase:YES];
    [[DaikiriCoreData manager] beginTransaction];
    
    
    Hero* batman                = [[DKFactory factory:Hero.class] create];
    Hero * spiderman            = [Hero createWith:@{@"id":@2, @"name":@"Spiderman"      ,@"age":@19}];
    Hero * superman             = [Hero createWith:@{@"id":@3, @"name":@"Superman"       ,@"age":@99}];
    
    Enemy* luxor                = [[DKFactory factory:Enemy.class] create];
    Enemy* greenGoblin          = [Enemy createWith:@{@"id":@2, @"name":@"Green Goblin"   ,@"age":@56}];
    Enemy* joker                = [Enemy createWith:@{@"id":@4, @"name":@"Joker"          ,@"age":@45}];
    
    [Friend createWith:@{@"id":@1, @"name":@"Robin"         ,@"hero_id":batman.id}];
    [Friend createWith:@{@"id":@2, @"name":@"Mary Jane"     ,@"hero_id":spiderman.id}];
    [Friend createWith:@{@"id":@3, @"name":@"Black cat"     ,@"hero_id":spiderman.id}];
    
    [EnemyHero createWith:@{@"id":@1, @"hero_id":batman.id      ,@"enemy_id":luxor.id, @"level":@7}];
    [EnemyHero createWith:@{@"id":@2, @"hero_id":superman.id    ,@"enemy_id":luxor.id, @"level":@5}];
    [EnemyHero createWith:@{@"id":@3, @"hero_id":batman.id      ,@"enemy_id":joker.id, @"level":@10}];
    [EnemyHero createWith:@{@"id":@4, @"hero_id":spiderman.id   ,@"enemy_id":greenGoblin.id, @"level":@10}];
}

- (void)tearDown {
    [super tearDown];
    [[DaikiriCoreData manager] rollback];
    //[[DaikiriCoreData manager] deleteAllEntities];
}

//===========================================================================
#pragma mark -
//===========================================================================
-(void)test_get{
    NSArray * heroes = Hero.query.get;  //Query builder
    XCTAssertEqual(3, heroes.count);
}

-(void)test_where{
    Hero* batman = [Hero find:@1];
    Enemy* joker = [Enemy find:@4];
    
    EnemyHero * enemyHero = [[EnemyHero.query
                              where:@"hero_id"  is:batman.id]
                              where:@"enemy_id" is:joker.id]
    .first;
    
    XCTAssertTrue([enemyHero.enemy.name isEqualToString:@"Joker"]);
    XCTAssertTrue([enemyHero.hero.name isEqualToString:@"Batman"]);
}

//TODO: test sort, and other querybuilder functions

@end
