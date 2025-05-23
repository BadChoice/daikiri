import XCTest
@testable import daikiri

class TransformablesTests: XCTestCase {
    override func setUp() {
        ValueTransformer.setValueTransformer(DriverTransformer(), forName: NSValueTransformerName("DriverTransformer"))
        DaikiriCoreData.manager().useTestDatabase(true)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
        
    func testDifferentTransformableAttributes() {
        let batman = Driver(id: 100, name: "Batman", age: 49, hasLicense: true)
        let sperman = Driver(id: 101, name: "Sperman", age: 29, hasLicense: false)
        
        Vehicle.create(with: [
            "id":1,
            "model": "Rolls-Royce Phantom II",
            "isCool": true,
            "nicknames": ["The Night Howler", "The Dark Ghost", "The Misbehaved"],
            "rules": [
                "smoking_allowed": true,
                "drunk_driving_policy": "just_on_fridays",
                "max_speed": "Mach 2",
                "passenger_seat_policy": "only_pretty_heroines",
            ],
            "drivers": [
                batman,
                sperman
            ]
        ])
        
        let coolVehicle = Vehicle.find(1)
        
        XCTAssertNotNil(coolVehicle)
                
        XCTAssertTrue(coolVehicle!.model == "Rolls-Royce Phantom II")
        
        XCTAssertTrue(coolVehicle!.isCool.boolValue)
        
        XCTAssertTrue(coolVehicle!.nicknames.count == 3)
        XCTAssertTrue(coolVehicle!.nicknames[1] as! String == "The Dark Ghost")
        
        XCTAssertTrue(coolVehicle!.rules!.count == 4)
        XCTAssertTrue(coolVehicle!.rules!["max_speed"] as! String == "Mach 2")
        
        XCTAssertTrue(coolVehicle!.drivers!.count == 2)
        XCTAssertTrue((coolVehicle!.drivers![0]).name == "Batman")
    }
}
