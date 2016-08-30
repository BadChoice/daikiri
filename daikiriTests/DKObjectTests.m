//
//  DKObjectTests.m
//  daikiri
//
//  Created by Badchoice on 16/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Hero.h"

@interface DKObjectTests : XCTestCase

@end

@implementation DKObjectTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCopy {
    Hero* original = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* copy     = [original copy];
    
    XCTAssertTrue( [original.name isEqualToString:copy.name]);
    XCTAssertTrue( [original.age isEqual:copy.age]);
    XCTAssertTrue( [original.headquarter.address isEqualToString:copy.headquarter.address]);
}

- (void)testEqual{
    Hero* hero      = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* equal     = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* notEqual1 = [Hero fromDictionary:@{@"name":@"spiderman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* notEqual2 = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"stark tower"}}];
    
    XCTAssertTrue( [hero isEqual:equal ]);
    XCTAssertFalse([hero isEqual:notEqual1]);
    XCTAssertFalse([hero isEqual:notEqual2]);
}

- (void)testHash{
    Hero* hero      = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* equal     = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* notEqual1 = [Hero fromDictionary:@{@"name":@"spiderman",@"age":@42,@"headquarter":@{@"address":@"batcave"}}];
    Hero* notEqual2 = [Hero fromDictionary:@{@"name":@"batman",@"age":@42,@"headquarter":@{@"address":@"stark tower"}}];
    
    XCTAssertTrue(  hero.hash == equal.hash     );
    XCTAssertFalse( hero.hash == notEqual1.hash );
    XCTAssertFalse( hero.hash == notEqual2.hash );
}

-(void) testProperties{
    NSMutableArray* propertiesArray = [NSMutableArray new];
    [Hero properties:^(NSString *name) {
        [propertiesArray addObject:name];
    }];
    
    XCTAssertTrue(propertiesArray.count == 3);
    XCTAssertTrue([propertiesArray[0] isEqualToString:@"name"]);
    XCTAssertTrue([propertiesArray[1] isEqualToString:@"age"]);
    XCTAssertTrue([propertiesArray[2] isEqualToString:@"headquarter"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
