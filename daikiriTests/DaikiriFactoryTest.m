#import <XCTest/XCTest.h>
#import "Hero.h"
#import "DKFactory.h"

@interface DaikiriFactoryTest : XCTestCase

@end

@implementation DaikiriFactoryTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_faker_returns_different_instances{
    [DKFactory define:Hero.class builder:^NSDictionary *(DKFaker *faker) {
        return @{
                @"name" : faker.name,
                @"age" : faker.number
        };
    }];

    Hero * h1 = [factory(Hero.class) make];
    Hero * h2 = [factory(Hero.class) make];

    XCTAssertNotEqual(h1.name, h2.name);
    XCTAssertNotNil(h1.name);
    XCTAssertNotNil(h2.name);
}

@end
