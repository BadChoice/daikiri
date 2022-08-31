//
//  DaikiriCoreData.m
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
#import "GSEnemy.h"

#import "DaikiriCoreData.h"

@interface DaikiriTests : XCTestCase

@end

@implementation DaikiriTests

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
- (void)test_create_with_dictionary {
    Hero * batman   = [Hero createWith:@{@"id":@100, @"name":@"Batman", @"age":@"49"}];
    Hero* found     = [Hero find:@100];
    
    XCTAssertTrue(batman.id.intValue == found.id.intValue);
    XCTAssertTrue([found.name isEqualToString:@"Batman"]);
}

-(void)test_update_with_dictionary{
    Hero * batman   = [Hero createWith:@{@"id":@100, @"name":@"Batman", @"age":@"49"}];
    [Hero updateWith:@{@"id":@100, @"name":@"Robin", @"age":@"20"}];
    Hero* found     = [Hero find:@100];
    
    XCTAssertTrue(batman.id.intValue == found.id.intValue);
    XCTAssertTrue([found.name isEqualToString:@"Robin"]);
    XCTAssertTrue(found.age.intValue == 20);
}

-(void)test_destroy_with_id{
    [Hero createWith:@{@"id":@100, @"name":@"Batman", @"age":@"49"}];
    [Hero destroyWith:@100];
    Hero* found     = [Hero find:@100];
    XCTAssertTrue(found == nil);
}

- (void)test_all {
    NSArray* allHeroes = Hero.all;
    XCTAssertTrue(allHeroes.count == 3);
}

-(void)test_all_sorted{
    NSArray* allHeroes = [Hero all:@"age"];
    Hero* h1 = allHeroes[0];
    Hero* h2 = allHeroes[1];
    Hero* h3 = allHeroes[2];
    
    XCTAssertTrue(h1.age.intValue < h2.age.intValue);
    XCTAssertTrue(h2.age.intValue < h3.age.intValue);
}

-(void)test_model_can_be_truncated{
    XCTAssertEqual(3, Hero.all.count);
    [Hero truncate];
    XCTAssertEqual(0, Hero.all.count);
}

//===========================================================================
#pragma mark - Relationships
//===========================================================================
-(void)test_find{
    Friend* f = [Friend find:@2];
    XCTAssertTrue(f.id.intValue == 2);
    XCTAssertTrue([f.name isEqualToString:@"Mary Jane"]);
}

-(void)test_belongs_to{
    Friend* robin = [Friend find:@1];
    XCTAssertTrue([robin.hero.name isEqualToString:@"Batman"]);
}

-(void)test_has_many{
    Hero* spiderman = [Hero find:@2];
    NSArray* friends = spiderman.friends;
    Friend* f1       = friends.firstObject;
    XCTAssertTrue(friends.count == 2);
    XCTAssertTrue([f1.name isEqualToString:@"Mary Jane"]);
}

-(void)test_belongs_to_many{
    Hero* batman        = [Hero find:@1];
    NSArray* enemies    = batman.enemies;
    Enemy* enemy1       = enemies[0];
    Enemy* enemy2       = enemies[1];
    
    XCTAssertTrue(enemies.count == 2);
    XCTAssertTrue([enemy1.name isEqualToString:@"Luxor"]);
    XCTAssertTrue(((EnemyHero*)enemy1.pivot).level.intValue == 7);
    
    XCTAssertTrue([enemy2.name isEqualToString:@"Joker"]);
    XCTAssertTrue(((EnemyHero*)enemy2.pivot).level.intValue == 10);
}

//===========================================================================
#pragma mark - Prefix
//===========================================================================
-(void)test_all_with_prefix{
    NSArray * heroes = [GSHero all];
    XCTAssertTrue(heroes.count == 3);
}

     
-(void)test_has_many_with_prefix{
    Hero* batman        = [Hero find:@1];
    NSArray* enemies    = batman.enemies;
    XCTAssertTrue(enemies.count == 2);
    XCTAssertTrue([((GSEnemy*)enemies.firstObject).name isEqualToString:@"Luxor"]);
} 

-(void)test_relationship_is_cached{
    Hero* batman        = [Hero find:@1];
    NSArray* enemies    = batman.enemies;
    XCTAssertEqual(enemies, batman.enemies);    //Belongs to many

    NSArray* friends    = batman.friends;
    XCTAssertEqual(friends, batman.friends);    //Has to many

    Friend* robin = [Friend find:@1];
    Hero * robinHero = robin.hero;
    XCTAssertEqual(robinHero, robin.hero);    //Belongs to
}

-(void)test_relationship_can_be_invalidated{
    Hero* batman        = [Hero find:@1];
    NSArray* enemies    = batman.enemies;
    XCTAssertEqual(enemies, batman.enemies);
    XCTAssertTrue(enemies.count == 2);
    NSArray* enemiesReloaded = ((Hero*)batman.invalidateRelationships).enemies;
    XCTAssertNotEqual(enemies, enemiesReloaded);
}

-(void)test_it_can_get_a_fresh_instance{
    Hero* batman        = [Hero find:@1];
    Hero* batman2       = [Hero find:@1];
    
    XCTAssertTrue([@"Batman" isEqualToString:batman.name]);
    XCTAssertTrue([@"Batman" isEqualToString:batman2.name]);
    
    batman2.name = @"Batman 2";
    [batman2 save];
    XCTAssertTrue([@"Batman 2" isEqualToString: batman2.name]);
    XCTAssertTrue([@"Batman" isEqualToString: batman.name]);
    XCTAssertTrue([@"Batman 2" isEqualToString: batman.fresh.name]);
    XCTAssertTrue([@"Batman" isEqualToString: batman.name]);
}

-(void)test_it_can_refresh_instance{
    Hero* batman        = [Hero find:@1];
    Hero* batman2       = [Hero find:@1];
    
    XCTAssertTrue([@"Batman" isEqualToString:batman.name]);
    XCTAssertTrue([@"Batman" isEqualToString:batman2.name]);
    
    batman2.name = @"Batman 2";
    [batman2 save];
    XCTAssertTrue([@"Batman 2" isEqualToString: batman2.name]);
    XCTAssertTrue([@"Batman" isEqualToString: batman.name]);
    XCTAssertTrue([@"Batman 2" isEqualToString: batman.refresh.name]);
    XCTAssertTrue([@"Batman 2" isEqualToString: batman.name]);
}

@end
