#import <XCTest/XCTest.h>
#import "Hero.h"
#import "DKFactory.h"
#import "DaikiriTestCase.h"

@interface DaikiriFactoryTest : DaikiriTestCase

@end

@implementation DaikiriFactoryTest

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
