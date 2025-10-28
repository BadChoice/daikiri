#import <XCTest/XCTest.h>
#import "DaikiriTestCase.h"
#import "Daikiri.h"
#import "DaikiriCoreData.h"

@implementation DaikiriTestCase

- (void)setUp {
    [super setUp];
    [Daikiri setSwiftPrefix:@"daikiri."];
    [[DaikiriCoreData manager] useTestDatabase:true];
    [[DaikiriCoreData manager] beginTransaction];
}

- (void)tearDown {
    [[DaikiriCoreData manager] rollback];
    [super tearDown];
}

@end
