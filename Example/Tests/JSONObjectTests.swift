import XCTest
import SVEJSONObject

class JSONObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONObjectSuccessfullReading() {
        guard let jsonURL = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "json"),
            let data = NSData(contentsOfURL: jsonURL),
            let jsonObject = try? JSONObject(data: data) else {
                XCTFail("Unable to read mock data")
                return
        }
        do {
            let aString = try jsonObject.objectAt("string").string()
            XCTAssertEqual(aString, "A string", "A string should be found")

            let aInteger = try jsonObject.objectAt("integer").int()
            XCTAssertEqual(aInteger, 1, "A integer should be found")

            let aDouble = try jsonObject.objectAt("double").double()
            XCTAssertEqual(aDouble, 3.14, "A double should be found")

            let aNull = try jsonObject.objectAt("null").null()
            XCTAssertEqual(aNull, NSNull(), "A null should be found")


        } catch {
            XCTFail("This code shouldn't throw any exception")
        }
    }

    func testJSONObjectSubscriptReading() {
        guard let jsonURL = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "json"),
            let data = NSData(contentsOfURL: jsonURL),
            let jsonObject = try? JSONObject(data: data) else {
                XCTFail("Unable to read mock data")
                return
        }
        do {
            let aString = try jsonObject["string"].string()
            XCTAssertEqual(aString, "A string", "A string should be found")

            let aInteger = try jsonObject["integer"].int()
            XCTAssertEqual(aInteger, 1, "A integer should be found")

            let aDouble = try jsonObject["double"].double()
            XCTAssertEqual(aDouble, 3.14, "A double should be found")

            let aNull = try jsonObject["null"].null()
            XCTAssertEqual(aNull, NSNull(), "A null should be found")

            var index = 1;
            for jsonString in jsonObject["arrayOfStrings"] {
                let string = try jsonString.string()
                XCTAssertEqual(string, "string \(index)", "A string should be found")
                index += 1
            }

            XCTAssertEqual(jsonObject["arrayOfStrings"].count, 3, "Count should be 3")

        } catch {
            XCTFail("This code shouldn't throw any exception")
        }
    }

    func testJSONExceptionThrow() {
        guard let jsonURL = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "json"),
            let data = NSData(contentsOfURL: jsonURL),
            let jsonObject = try? JSONObject(data: data) else {
                XCTFail("Unable to read mock data")
                return
        }

        XCTAssertThrowsError(try jsonObject["randomstring"].string(), "Should send exception") { (error) in
            XCTAssert(error is JSONValidationError, "exception error type should be a \(String(JSONValidationError))")
            if let jsonError = error as? JSONValidationError {
                switch jsonError {
                    case JSONValidationError.MissingKey(_, "randomstring"):
                        print(jsonError)
                        break;
                    default:
                        XCTFail("Error should have been a MissingKey")
                        break;
                }
            }
        }

        XCTAssertThrowsError(try jsonObject[7].string(), "Should send exception") { (error) in
            XCTAssert(error is JSONValidationError, "exception error type should be a \(String(JSONValidationError))")
            if let jsonError = error as? JSONValidationError {
                switch jsonError {
                case JSONValidationError.ConversionFailed(_, "Array"):
                    print(jsonError)
                    break;
                default:
                    XCTFail("Error should have been a ExpectedArray")
                    break;
                }
            }
        }

        XCTAssertThrowsError(try jsonObject["arrayOfIntegers"][7].int(), "Should send exception") { (error) in
            XCTAssert(error is JSONValidationError, "exception error type should be a \(String(JSONValidationError))")
            if let jsonError = error as? JSONValidationError {
                switch jsonError {
                case JSONValidationError.MissingIndex(_, 7):
                    print(jsonError)
                    break;
                default:
                    XCTFail("Error should have been a MissingIndex")
                    break;
                }
            }
        }
    }
    
}
