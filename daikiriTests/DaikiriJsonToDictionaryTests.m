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
    Hero * h    = [Hero new];
    h.name      = @"Batman";
    h.age       = @46;
    
    NSDictionary* result = h.toDictionary;
    
    XCTAssert([result[@"name"] isEqualToString:@"Batman"]);
    XCTAssert([result[@"age"]  isEqual:@46]);
}

-(void)testToDictionaryNilKeyIsNSNull{
    Hero * h    = [Hero new];
    h.name      = @"Batman";
    h.age       = @46;
    
    NSDictionary* result = h.toDictionary;
    
    XCTAssert( [result[@"headquarter"] isKindOfClass:NSNull.class] );
}

-(void)testToDicitonaryNonDaikiriArray{
    SampleModel * s = [SampleModel new];
    s.numbers       = @[@1, @2, @3, @4];
    
    NSDictionary* result = s.toDictionary;
    
    XCTAssert([result[@"numbers"] isKindOfClass:NSArray.class]);
    NSArray* numbers = result[@"numbers"];
    XCTAssert(numbers.count == 4);
    XCTAssert([numbers[0] isEqual:@1]);
}

-(void)testToDicitonaryDaikiriArray{
    Headquarter * h     = [Headquarter new];
    Vehicle     * v1    = [Vehicle new];
    Vehicle     * v2    = [Vehicle new];
    v1.model    = @"Batmobile";
    v2.model    = @"Spidermobile";
    h.vehicles = @[v1,v2];
    
    NSDictionary* result = h.toDictionary;
    
    NSArray* vehicles   = result[@"vehicles"];
    
    XCTAssert( [result[@"vehicles"] isKindOfClass:NSArray.class] );
    XCTAssert( vehicles.count == 2);
    XCTAssert( [vehicles[0][@"model"] isEqualToString:@"Batmobile"] );
}

-(void)testToDictionaryDaikiriNestedModel{
    Hero* h         = [Hero new];
    h.name          = @"Batman";
    Headquarter* hq = [Headquarter new];
    hq.address      = @"Batcave";
    h.headquarter   = hq;
    
    NSDictionary* result = h.toDictionary;
    
    XCTAssert( [result[@"headquarter"] isKindOfClass:NSDictionary.class]);
    XCTAssert( [result[@"headquarter"][@"address"] isEqualToString:@"Batcave"]);
}

-(void)testToDictionaryNonDaikiriNestedModel{
    SampleModel* sm         = [SampleModel new];
    sm.name                 = @"Hello";
    NonDaikiri* nonDaikiri  = [NonDaikiri new];
    nonDaikiri.name         = @"Bye";
    sm.nonDaikiri           = nonDaikiri;
    
    XCTAssertThrows(sm.toDictionary);
}

-(void)testToDictionaryIngnoredKeys{
    SampleModel* sm     = [SampleModel new];
    sm.name             = @"Hello";
    sm.toBeIgnored      = @"Ignore me";
    
    NSDictionary* result = sm.toDictionary;
    XCTAssert(result[@"toBeIgnored"] == nil);    
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        NSDictionary* d = @{
                            @"name" : @"Batman",
                            @"age"  : @10,
                            @"headquarter":@{
                                    @"address" : @"patata",
                                    @"isActive" : @1,
                                    @"vehicles"   : @[
                                            @{@"model" : @"Batmobile"},
                                            @{@"model" : @"Batwing"},
                                            @{@"model" : @"Tumbler"},
                                            ]
                                    }
                            };
        
        Hero * model = [Hero fromDictionary:d];
        [model toDictionary];        
    }];
}

@end
