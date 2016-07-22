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

@interface QueryBuilderTests : XCTestCase

@end

@implementation QueryBuilderTests

- (void)setUp {
    [super setUp];
    
    Hero * batman               = [Hero createWith:@{@"id":@1, @"name":@"Batman"         ,@"age":@"49"}];
    Hero * spiderman            = [Hero createWith:@{@"id":@2, @"name":@"Spiderman"      ,@"age":@19}];
    Hero * superman             = [Hero createWith:@{@"id":@3, @"name":@"Superman"       ,@"age":@99}];
    
    Enemy* luxor                = [Enemy createWith:@{@"id":@1, @"name":@"Luxor"          ,@"age":@32}];
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
    [Hero       destroyWithArray:@[@1,@2,@3,@100]];
    [Enemy      destroyWithArray:@[@1,@2,@4]];
    [Friend     destroyWithArray:@[@1,@2,@4]];
    [EnemyHero  destroyWithArray:@[@1,@2,@3,@4]];
    [super tearDown];
}

//===========================================================================
#pragma mark -
//===========================================================================
-(void)test_get{
    NSArray * heroes = Hero.query.get;  //Query builder
    XCTAssertTrue(heroes.count == 3);
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
