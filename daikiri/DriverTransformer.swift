public class DriverTransformer: ValueTransformer {
    
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? Driver else { return nil }
        
        do {
            return try JSONEncoder().encode(value)
        } catch {
            print("Error encoding \(Driver.self): \(error)")
            return nil
        }
    }

    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try JSONDecoder().decode(Driver.self, from: data)
        } catch {
            print("Error decoding \(Driver.self): \(error)")
            return nil
        }
    }
}
