import XCTest
import SVEJSONObject

class JSONObjectBenchmarkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONObjectHandlingPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            for _ in 0..<1000 {
                let json = JSONObject(json: self.object)
                let _ = Struct(jason: json)
            }
        }
    }

    struct Struct {
        let string: String
        let int: Int
        let double: Double
        let float: Float
        let bool: Bool
        let array: [AnyObject]
        let dictionary: [String: AnyObject]
        let optionalFloat: Float?
        let optionalString: String?
        let optionalInt: Int?
        let optionalDouble: Double?
        let optionalBool: Bool?
        let optionalArray: [AnyObject]?
        let optionalDictionary: [String: AnyObject]?

        init?(jason json: JSONObject) {
            do {
                string = try json["string"].string()
                int = try json["int"].int()
                double = try json["double"].double()
                float = try json["float"].float()
                bool = try json["bool"].bool()
                array = try json["array"].array()
                dictionary = try json["dictionary"].dictionary()

                optionalString = try json["string"].string()
                optionalInt = try json["int"].int()
                optionalDouble = try json["double"].double()
                optionalFloat = try json["float"].float()
                optionalBool = try json["bool"].bool()
                optionalArray = try json["array"].array()
                optionalDictionary = try json["dictionary"].dictionary()
            } catch {
                return nil
            }
        }
    }

    let object: AnyObject = [
        "string": "string",
        "int": 42,
        "double": 42,
        "float": 42,
        "bool": true,
        "array": ["one", "two", "three"],
        "dictionary": ["string": "string", "int": 42]
    ]
}
