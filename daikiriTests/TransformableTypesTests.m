#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "Daikiri.h"
#import "DaikiriCoreData.h"
#import "Vehicle.h"

@interface TransformableTypesTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSEntityDescription *entity;

@end

@implementation TransformableTypesTests

- (void)setUp {
    [[DaikiriCoreData manager] useTestDatabase:true];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Simple Type Test

- (void)testDifferentTransformableAttributes{
    Vehicle* coolVehicle = [Vehicle createWith:@{
        @"id":@1,
        @"model": @"Rolls-Royce Phantom II",
        @"isCool":@YES,
        @"nicknames": @[@"The Night Howler", @"The Dark Ghost", @"The Misbehaved"],
        @"rules": @{
            @"smoking_allowed": @YES,
            @"drunk_driving_policy": @"just_on_fridays",
            @"max_speed": @"Mach 2",
            @"passenger_seat_policy": @"only_pretty_heroines",
        },
    }];
    
    XCTAssertTrue([coolVehicle.model isEqualToString:@"Rolls-Royce Phantom II"]);
    
    XCTAssertEqual(coolVehicle.isCool.boolValue, YES);
    
    XCTAssertTrue(coolVehicle.nicknames.count == 3);
    XCTAssertTrue([((NSString*)coolVehicle.nicknames[1]) isEqualToString:@"The Dark Ghost"]);
    
    XCTAssertTrue(coolVehicle.rules.count == 4);
    XCTAssertTrue([((NSString*)coolVehicle.rules[@"max_speed"]) isEqualToString:@"Mach 2"]);
}

- (void)testEdgeCases{
    Vehicle* coolVehicle = [Vehicle createWith:@{
        @"id":@1,
        @"model": @"",
        @"isCool":@YES,
        @"nicknames": @[],
        //@"rules": nil,
    }];
    
    XCTAssertTrue([coolVehicle.model isEqualToString:@""]);
    
    XCTAssertEqual(coolVehicle.isCool.boolValue, YES);
    
    XCTAssertTrue(coolVehicle.nicknames.count == 0);
    
    XCTAssertTrue(coolVehicle.rules.count == 0);
}

@end 
