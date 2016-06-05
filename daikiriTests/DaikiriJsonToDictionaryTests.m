//
//  DaikiriToDictionaryTests.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 5/6/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Hero.h"
#import "SampleModel.h"
#import "Vehicle.h"

@interface DaikiriJsonToDictionaryTests : XCTestCase

@end

@implementation DaikiriJsonToDictionaryTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//============================================================
#pragma mark - Tests
//============================================================
- (void)testToDictionary {
    Hero * h    = [[Hero alloc] init];
    h.name      = @"Batman";
    h.age       = @46;
    
    NSDictionary* result = h.toDictionary;
    
    XCTAssert([result[@"name"] isEqualToString:@"Batman"]);
    XCTAssert([result[@"age"]  isEqual:@46]);
}

-(void)testToDictionaryNilKeyIsNSNull{
    Hero * h    = [[Hero alloc] init];
    h.name      = @"Batman";
    h.age       = @46;
    
    NSDictionary* result = h.toDictionary;
    
    XCTAssert( [result[@"headquarter"] isKindOfClass:[NSNull class]] );
}

-(void)testToDicitonaryNonDaikiriArray{
    SampleModel * s = [[SampleModel alloc] init];
    s.numbers       = @[@1, @2, @3, @4];
    
    NSDictionary* result = s.toDictionary;
    
    XCTAssert([result[@"numbers"] isKindOfClass:[NSArray class]]);
    NSArray* numbers = result[@"numbers"];
    XCTAssert(numbers.count == 4);
    XCTAssert([numbers[0] isEqual:@1]);
}

-(void)testToDicitonaryDaikiriArray{
    Headquarter * h     = [[Headquarter alloc] init];
    Vehicle     * v1    = [[Vehicle alloc] init];
    Vehicle     * v2    = [[Vehicle alloc] init];
    v1.model    = @"Batmobile";
    v2.model    = @"Spidermobile";
    h.vehicles = @[v1,v2];
    
    NSDictionary* result = h.toDictionary;
    
    NSArray* vehicles   = result[@"vehicles"];
    
    XCTAssert( [result[@"vehicles"] isKindOfClass:[NSArray class]] );
    XCTAssert( vehicles.count == 2);
    XCTAssert( [vehicles[0][@"model"] isEqualToString:@"Batmobile"] );
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        
    }];
}

@end
