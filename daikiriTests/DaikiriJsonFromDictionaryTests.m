//
//  daikiriTests.m
//  daikiriTests
//
//  Created by Jordi Puigdellívol on 5/6/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DaikiriJSON.h"
#import "SampleModel.h"
#import "Hero.h"
#import "Friend.h"
#import "Vehicle.h"

@interface DaikiriJsonFromDictionaryTests : XCTestCase

@end

@implementation DaikiriJsonFromDictionaryTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//============================================================
#pragma mark - Tests
//============================================================
- (void)testFromDictionary {
    SampleModel* sm = [SampleModel fromDictionary:@{
                                                    @"name":@"A sample model",
                                                    @"numbers":@[@1,@2,@3,@4]
                                                    }];
    
    XCTAssert( [sm.name     isEqualToString:@"A sample model"]);
    XCTAssert( [sm.numbers  isKindOfClass:[NSArray class]]);
    XCTAssert( sm.numbers.count == 4 );
    XCTAssert( [sm.numbers[0] isEqual:@1] );
}

- (void)testFromDictionaryString {
    NSString* dictString = @"{\"name\":\"A sample model\",\"numbers\":[1,2,3,4]}";
    SampleModel* sm = [SampleModel fromDictionaryString:dictString];
    
    XCTAssert( [sm.name     isEqualToString:@"A sample model"]);
    XCTAssert( [sm.numbers  isKindOfClass:[NSArray class]]);
    XCTAssert( sm.numbers.count == 4 );
    XCTAssert( [sm.numbers[0] isEqual:@1] );
}

-(void)testFromDictionaryWithNonExistingKeys{
    SampleModel* sm = [SampleModel fromDictionary:@{
                                                    @"name":@"A sample model",
                                                    @"nonExistingKey" : @"hola",
                                                    }];
    
    XCTAssert([sm.name isEqualToString:@"A sample model"]);
    
}

-(void)testFromDictionaryWithNullKeys{
    SampleModel* sm = [SampleModel fromDictionary:@{
                                                    @"name"     : @"A sample model",
                                                    @"numbers"  : [NSNull null],
                                                    }];
    
    XCTAssert([sm.name isEqualToString:@"A sample model"]);
    XCTAssertNil(sm.numbers);
}

-(void)testFromDictionaryWithNestedModel{
    NSDictionary* d = @{
                        @"name" : @"Batman",
                        @"age"  : @10,
                        @"headquarter":@{
                                @"address" : @"patata",
                                @"isActive" : @1,
                                }
                        };

    Hero * model = [Hero fromDictionary:d];
    
    XCTAssert( [model.headquarter isKindOfClass:[Headquarter class]] );
    XCTAssert( [model.headquarter.address isEqualToString:@"patata"] );
    
}

-(void)testFromDictionaryWithNonDaikiriNestedModelThrowsException{
    NSDictionary* dict = @{
                           @"name":@"A sample model",
                           @"numbers":@[@1,@2,@3,@4],
                           @"nonDaikiri":@{
                                   @"name"     : @"a name",
                                   @"lastName" : @"a last name"
                                   }
                           };
    
    XCTAssertThrows([SampleModel fromDictionary:dict]);

}

-(void)testFromDictionaryWithNestedModelArray{
    NSDictionary* d = @{
                        @"address" : @"patata",
                        @"isActive" : @1,
                        @"vehicles"   : @[
                                @{@"model" : @"Batmobile"},
                                @{@"model" : @"Batwing"},
                                @{@"model" : @"Tumbler"},
                                ]
                        };
    
    Headquarter * h = [Headquarter fromDictionary:d];
    
    XCTAssert ( [h.vehicles     isKindOfClass:[NSArray class]]);
    XCTAssert ( [h.vehicles[0]  isKindOfClass:[Vehicle class]]);
    XCTAssert ( [[h.vehicles[0]  valueForKey:@"model"] isEqualToString:@"Batmobile"]);
    
}

-(void)testFromDictionaryWithUndefinedValue{
    SampleModel* sm = [SampleModel fromDictionary:@{
                                                    @"name":@"A sample model",
                                                    @"numbers":@[@1,@2,@3,@4],
                                                    @"undefinedKey":@"undefined",
                                                    }];
    XCTAssert(sm != nil);
}

-(void)testFromDictionaryWithoutDictionary{
    XCTAssertThrows([SampleModel fromDictionary:((NSDictionary*)@"a non dictionary")]);
    
}

-(void)testFromDictionaryWithNil{
    SampleModel* sm = [SampleModel fromDictionary:nil];
    XCTAssert(sm == nil);
}

-(void)testCopy{
    SampleModel* sm = [SampleModel fromDictionary:@{
                                                    @"name":@"A sample model",
                                                    @"numbers":@[@1,@2,@3,@4]
                                                    }];
    
    SampleModel* copy = [sm copy];
    
    XCTAssertTrue ([sm isEqual:copy]);
    
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        [SampleModel fromDictionary:@{
                                      @"name":@"A sample model",
                                      @"numbers":@[@1,@2,@3,@4]
                                      }];
    }];
}

@end
