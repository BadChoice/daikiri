import Foundation

@objc class Driver: NSObject, Codable {
    let id: Int
    let name:String
    let age:Int?
    let hasLicense:Bool
    
    init(id: Int, name: String, age: Int?, hasLicense: Bool) {
        self.id = id
        self.name = name
        self.age = age
        self.hasLicense = hasLicense
    }
}
