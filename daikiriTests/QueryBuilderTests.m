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

    [DKFactoryDefinition registerFactories:@[
            HeroFactory.new
    ]];
    
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

-(void)test_can_get_first{
    Hero* hero = Hero.first;
    XCTAssertEqual(@"Batman", hero.name);
}

-(void)test_can_skip_some{
    NSArray* result     = [Hero.query skip:1].get;
    NSArray* result2    = [Hero.query skip:2].get;
    
    XCTAssertEqual(2, result.count);
    XCTAssertEqual(1, result2.count);
    XCTAssertEqual(@"Spiderman", ((Hero*)result[0]).name);
    XCTAssertEqual(@"Superman",  ((Hero*)result2[0]).name);
}

-(void)test_can_take_some{
    NSArray* result     = [Hero.query take:1].get;
    NSArray* result2    = [Hero.query take:2].get;
    
    XCTAssertEqual(1, result.count);
    XCTAssertEqual(2, result2.count);
    XCTAssertEqual(@"Batman", ((Hero*)result[0]).name);
    XCTAssertEqual(@"Batman", ((Hero*)result2[0]).name);
}

-(void)test_can_skip_and_take{
    NSArray* result = [[Hero.query skip:1] take:1].get;
    
    XCTAssertEqual(1, result.count);
    XCTAssertEqual(@"Spiderman",   ((Hero*)result[0]).name);
}

-(void)test_can_do_complex_query{
    [Hero createWith:@{@"id": @(200), @"name":@"hello the baby"}];
    [Hero createWith:@{@"id": @(201),@"name":@"hello baby"}];
    [Hero createWith:@{@"id": @(202),@"name":@"another one"}];

    NSArray* all = Hero.all;
    XCTAssertEqual(6, all.count);

    NSArray* result = [Hero.query where:@"name" operator:@"like" value:@"hello baby"].get;

    XCTAssertEqual(2, result.count);
}

-(void)test_can_count_query{
    [Hero createWith:@{@"id": @(200), @"name":@"hello the baby"}];
    [Hero createWith:@{@"id": @(201), @"name":@"hello baby"}];
    [Hero createWith:@{@"id": @(202), @"name":@"another one"}];
    
    XCTAssertEqual(6, Hero.query.count);
}

-(void)test_can_do_a_where_any_like_query{
    
    NSArray* result     = [Hero.query whereAny:@[@"name",@"age"] like:@"erman"].get;
    NSArray* result2    = [Hero.query whereAny:@[@"name",@"age"] like:@9].get;
    
    XCTAssertEqual(2, result.count);
    XCTAssertEqual(3, result2.count);
}

-(void)test_can_do_a_where_any_is_query{
    NSArray* result     = [Hero.query whereAny:@[@"name",@"age"] is:@"erman"].get;
    NSArray* result2    = [Hero.query whereAny:@[@"name",@"age"] is:@"Superman"].get;
    NSArray* result3    = [Hero.query whereAny:@[@"name",@"age"] is:@19].get;
    
    XCTAssertEqual(0, result.count);
    XCTAssertEqual(1, result2.count);
    XCTAssertEqual(1, result3.count);
}

-(void)test_wherein{
    NSArray* result     = [Hero.query where:@"name" in:@[@"Spiderman", @"Superman", @"Hulk"]].get;
    NSArray* result2    = [Hero.query where:@"name" in:nil].get;
    
    XCTAssertEqual(2, result.count);
    XCTAssertEqual(0, result2.count);
}

-(void)test_can_do_query_builder_in_multiple_threads{
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Excpecttion 1"];
    dispatch_async(dispatch_get_main_queue(), ^{
        for(int i = 0; i< 1000; i++){
            Hero * h = [Hero createWith:@{@"name":@"a hero", @"id": @(i)}];
            XCTAssertNotNil(h);
            [Hero updateWith:@{@"id" : @(1), @"name" : @"a hero 2"}];
        }
        [expectation1 fulfill];
    });
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Excpecttion 2"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 0; i< 1000; i++){
            Enemy* e = [Enemy createWith:@{@"name":@"an enemy", @"id": @(i)}];
            XCTAssertNotNil(e);
            [Enemy updateWith:@{@"id" : @(1), @"name" : @"an enemy 2"}];
        }
        [expectation2 fulfill];
    });
    
    [self waitForExpectationsWithTimeout:25.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}





//TODO: test sort, and other querybuilder functions

@end
