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
    self.entity = [NSEntityDescription entityForName:@"TransformableEntity" inManagedObjectContext:self.context];
    XCTAssertNotNil(self.entity, @"Failed to get TransformableEntity");
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
    [object setValue:@YES forKey:@"boolValue"];
    NSNumber *transformedTrue = [object valueForKey:@"boolValue"];
    XCTAssertEqual([transformedTrue boolValue], YES);
    
    // Test false value
    [object setValue:@NO forKey:@"boolValue"];
    NSNumber *transformedFalse = [object valueForKey:@"boolValue"];
    XCTAssertEqual([transformedFalse boolValue], NO);
}

#pragma mark - Array Test

- (void)testStringArrayTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    NSArray *testArray = @[@"test1", @"test2", @"test3"];
    [object setValue:testArray forKey:@"stringArray"];
    NSArray *transformedArray = [object valueForKey:@"stringArray"];
    
    XCTAssertEqualObjects(transformedArray, testArray);
}

#pragma mark - Dictionary Test

- (void)testStringDictionaryTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    NSDictionary *testDict = @{@"key1": @"value1", @"key2": @"value2"};
    [object setValue:testDict forKey:@"stringDict"];
    NSDictionary *transformedDict = [object valueForKey:@"stringDict"];
    
    XCTAssertEqualObjects(transformedDict, testDict);
}

#pragma mark - Edge Cases

- (void)testNilValueTransformation {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:self.entity insertIntoManagedObjectContext:self.context];
    
    [object setValue:nil forKey:@"boolValue"];
    id transformedValue = [object valueForKey:@"boolValue"];
    
    XCTAssertNil(transformedValue);
}

@end 
