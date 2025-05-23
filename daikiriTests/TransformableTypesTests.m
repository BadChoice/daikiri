#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "Daikiri.h"
#import "DaikiriCoreData.h"

@interface TransformableTypesTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSEntityDescription *entity;

@end

@implementation TransformableTypesTests

- (void)setUp {
    [super setUp];
    self.context = [DaikiriCoreData manager].managedObjectContext;
    self.entity = [NSEntityDescription entityForName:@"HeroVehicle" inManagedObjectContext:self.context];
    XCTAssertNotNil(self.entity, @"Failed to get HeroVehicle");
}

- (void)tearDown {
    self.context = nil;
    self.entity = nil;
    [super tearDown];
}

#pragma mark - Simple Type Test

- (void)testBoolTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    // Test true value
    [object setValue:@YES forKey:@"isCool"];
    NSNumber *transformedTrue = [object valueForKey:@"isCool"];
    XCTAssertEqual([transformedTrue boolValue], YES);
    
    // Test false value
    [object setValue:@NO forKey:@"isCool"];
    NSNumber *transformedFalse = [object valueForKey:@"isCool"];
    XCTAssertEqual([transformedFalse boolValue], NO);
}

#pragma mark - Array Test

- (void)testStringArrayTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    NSArray *testArray = @[@"test1", @"test2", @"test3"];
    [object setValue:testArray forKey:@"nicknames"];
    NSArray *transformedArray = [object valueForKey:@"nicknames"];
    
    XCTAssertEqualObjects(transformedArray, testArray);
}

#pragma mark - Dictionary Test

- (void)testStringDictionaryTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    NSDictionary *testDict = @{@"smoking_allowed": @"false", @"drunk_driving_allowed": @"just_on_fridays"};
    [object setValue:testDict forKey:@"rules"];
    NSDictionary *transformedDict = [object valueForKey:@"rules"];
    
    XCTAssertEqualObjects(transformedDict, testDict);
}

#pragma mark - Edge Cases

- (void)testNilValueTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    [object setValue:nil forKey:@"isCool"];
    id transformedValue = [object valueForKey:@"isCool"];
    
    XCTAssertNil(transformedValue);
}

@end 
