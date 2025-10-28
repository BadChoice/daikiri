//
//  DaikiriMultipleAccounts.m
//  daikiriTests
//
//  Created by Eduard Duocastella Altimira on 9/10/17.
//  Copyright © 2017 revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Hero.h"
#import "Enemy.h"
#import "Friend.h"
#import "EnemyHero.h"

#import "DaikiriCoreData.h"


@interface DaikiriMultipleAccounts : XCTestCase

@end

@implementation DaikiriMultipleAccounts

- (void)setUp {
    [super setUp];
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db"];
    
    [Hero createWith:@{@"id":@1, @"name":@"Batman"         ,@"age":@"49"}];
    [Hero createWith:@{@"id":@2, @"name":@"Spiderman"      ,@"age":@19}];
    [Hero createWith:@{@"id":@3, @"name":@"Superman"       ,@"age":@99}];
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db2"];
    
    [Hero createWith:@{@"id":@1, @"name":@"Batman2"         ,@"age":@"49"}];
    [Hero createWith:@{@"id":@2, @"name":@"Spiderman2"      ,@"age":@19}];
    
    [Enemy createWith:@{@"id":@1, @"name":@"Luxor2"          ,@"age":@32}];
    [Enemy createWith:@{@"id":@2, @"name":@"Green Goblin2"   ,@"age":@56}];
    [Enemy createWith:@{@"id":@4, @"name":@"Joker2"          ,@"age":@45}];
}

- (void)tearDown {
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db"];
    [[DaikiriCoreData manager] deleteDatabase];
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db2"];
    [[DaikiriCoreData manager] deleteDatabase];
    
    [super tearDown];
}

//===========================================================================
#pragma mark -
//===========================================================================
- (void)test_can_change_connection {
    [[DaikiriCoreData manager] setDefaultConnection:@"db"];
    
    XCTAssertEqual([Hero all].count, 3);
    XCTAssertEqualObjects(((Hero*)[Hero first]).name, @"Batman");
    XCTAssertEqual([Enemy all].count, 0);
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db2"];
    
    XCTAssertEqual([Hero all].count, 2);
    XCTAssertEqual([Enemy all].count, 3);
    XCTAssertEqualObjects(((Hero*)[Hero first]).name, @"Batman2");
    
    [Hero createWith:@{@"id":@5, @"name":@"Batman new"         ,@"age":@"49"}];
    [Hero createWith:@{@"id":@6, @"name":@"Batman new2"         ,@"age":@"49"}];
    XCTAssertEqual([Hero all].count, 4);
    
    XCTAssertEqualObjects(((Hero*)[Hero find:@6]).name, @"Batman new2");
    XCTAssertEqualObjects(((Enemy*)[Enemy find:@2]).name, @"Green Goblin2");
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db"];
    XCTAssertEqual([Hero all].count, 3);
    XCTAssertEqualObjects(((Hero*)[Hero first]).name, @"Batman");
}

- (void)test_can_delete_data {
    
    [[DaikiriCoreData manager] setDefaultConnection:@"db2"];
    [[DaikiriCoreData manager] deleteDatabase];
    XCTAssertEqual([Enemy all].count, 0);
    [[DaikiriCoreData manager] setDefaultConnection:@"db"];
    XCTAssertEqual([Hero all].count, 3);
    [[DaikiriCoreData manager] deleteDatabase];
    XCTAssertEqual([Hero all].count, 0);
}

@end
