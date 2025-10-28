import XCTest
@testable import daikiri

final class PropertiesTests: DaikiriTestCase {

    func test_can_save_properties_to_nil() throws {
        SwiftHero.create(with: ["id": 1, "name": "Batman", "age": 49])
        let batman = SwiftHero.find(1)
        XCTAssertNotNil(batman)
        XCTAssertTrue(batman?.age == 49)
        
        batman?.age = nil
        batman?.save()
        
        XCTAssertTrue(batman?.age == nil)
        XCTAssertTrue(batman?.fresh().age == nil)
        XCTAssertTrue(SwiftHero.find(1)?.age == nil)
        
    }

}
