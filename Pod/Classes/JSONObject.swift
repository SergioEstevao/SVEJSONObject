import Foundation

// MARK: - JSONObject

/// JSONObject is class to handle JSON objects in type safe way.
/// When you try to access a value from the JSON object and it's type doesn't match or the index used is
/// not correct it will throw an JSONValidationError
public class JSONObject {

    private let json: AnyObject?
    private let error: ErrorType?
    public let path: String
    private var cachedDictionary:[String:AnyObject]? = nil
    private var cachedArray:[AnyObject]? = nil

    public convenience init(url: NSURL) throws {
        let data = try NSData(contentsOfURL: url, options: NSDataReadingOptions())
        try self.init(data: data)
    }

    public convenience init(data: NSData) throws {
        let object = try NSJSONSerialization.JSONObjectWithData(data,  options: NSJSONReadingOptions())
        self.init(json: object)
    }

    public init(json: AnyObject?, path: String = "Root") {
        self.json = json
        self.path = path
        error = nil
    }

    private init(error: ErrorType) {
        json = nil
        self.path = ""
        self.error = error
    }

    private func throwIfInErrorState() throws {
        if let error = self.error {
            throw error
        }
    }

    /// Returns a dictionary with the format [String: AnyObject] if it's available
    public func dictionary() throws -> [String: AnyObject] {
        try throwIfInErrorState()
        guard let dictionary = json as? [String: AnyObject] else {
            throw JSONValidationError.ConversionFailed(path, "Dictionary")
        }
        return dictionary
    }

    /// Returns an array with the format [AnyObject] if it's available
    public func array() throws -> [AnyObject] {
        try throwIfInErrorState()
        guard let array = json as? [AnyObject] else {
            throw JSONValidationError.ConversionFailed(path, "Array")
        }
        return array
    }

    /// Returns a string object if available
    public func string() throws -> String {
        try throwIfInErrorState()
        guard let result = json as? String else {
            throw JSONValidationError.ConversionFailed(path, "String")
        }
        return result
    }

    /// Returns a int object if available
    public func int() throws -> Int {
        try throwIfInErrorState()
        guard let result = json as? Int else {
            throw JSONValidationError.ConversionFailed(path, "Int")
        }
        return result
    }

    /// Returns a double object if available
    public func double() throws -> Double {
        try throwIfInErrorState()
        guard let result = json as? Double else {
            throw JSONValidationError.ConversionFailed(path, "Double")
        }
        return result
    }

    /// Returns a float object if available
    public func float() throws -> Float {
        try throwIfInErrorState()
        guard let result = json as? Float else {
            throw JSONValidationError.ConversionFailed(path, "Float")
        }
        return result
    }

    /// Return a bool object if available
    public func bool() throws -> Bool {
        try throwIfInErrorState()
        guard let result = json as? Bool else {
            throw JSONValidationError.ConversionFailed(path, "Bool")
        }
        return result
    }

    /// Return a NSNull object if available
    public func null() throws -> NSNull {
        try throwIfInErrorState()
        guard let result = json as? NSNull else {
            throw JSONValidationError.ConversionFailed(path, "NSNull")
        }
        return result;
    }    

    /// Return an JSONObject object that is in the key value of the dictionary if available
    public func objectAt(key: String) throws -> JSONObject {
        try throwIfInErrorState()
        if (cachedDictionary == nil) {
            guard let dictionary = json as? [String: AnyObject] else {
                throw JSONValidationError.ConversionFailed(path, "Dictionary")
            }
            cachedDictionary = dictionary
        }

        guard let safeDictionary = cachedDictionary,
              let obj = safeDictionary[key] else {
            throw JSONValidationError.MissingKey(path, key)
        }

        return JSONObject(json: obj, path:path + "->\(key)")
    }

    /// Return an JSONObject object that is in the index value of the array if available
    public func objectAt(index: Int) throws -> JSONObject {
        try throwIfInErrorState()
        if (cachedArray == nil) {
            guard let array = json as? [AnyObject] else {
                throw JSONValidationError.ConversionFailed(path, "Array")
            }
            cachedArray = array
        }

        guard let safeArray = cachedArray where
            (index >= 0) && (index < safeArray.count) else {
            throw JSONValidationError.MissingIndex(path, index)
        }

        let obj = safeArray[index]

        return JSONObject(json: obj, path:path + "->[\(index)]")
    }

    public subscript(index:String) -> JSONObject {
        do {
            return try objectAt(index)
        } catch {
            return JSONObject(error:error)
        }

    }

    public subscript(index:Int) -> JSONObject {
        do {
            return try objectAt(index)
        } catch {
            return JSONObject(error:error)
        }

    }

    /// Return the total number of json object available at the current level of the JSON hierarchy
    public var count: Int {
        if let array = json as? [AnyObject] {
            return array.count
        }
        if let dictionary = json as? [String:AnyObject] {
            return dictionary.count
        }
        return 1
    }
}

extension JSONObject: SequenceType {

    public func generate() -> IndexingGenerator<[JSONObject]> {
        if let array = json as? [AnyObject] {
            return array.enumerate().map({ (index, obj) -> JSONObject in
                JSONObject(json:obj, path: path + "[\(index)]")
            }).generate()
        }
        if let dictionary = json as? [String:AnyObject] {
            return dictionary.map({ (obj) -> JSONObject in
                JSONObject(json:obj.1, path:path + "->\(obj.0)")
            }).generate()
        }
        return Array<JSONObject>().generate()
    }

}

// Helper methods
extension JSONObject {

    /// Reads a date from the json object using the dateFormatter provided
    public func dateWithFormatter(dateFormatter: NSDateFormatter) throws -> NSDate {
        try throwIfInErrorState()
        let dateString = try self.string() as String
        guard let date = dateFormatter.dateFromString(dateString) else {
            throw JSONValidationError.ConversionFailed(path, "Date")
        }

        return date
    }
}

// MARK: - JSONObject errors

/// Error enum for JSON data retrieval and type validation errors.
public enum JSONValidationError: ErrorType, CustomDebugStringConvertible, CustomStringConvertible {
    case ConversionFailed(String, String)
    case MissingIndex(String, Int)
    case MissingKey(String, String)

    func localizedFailureReason() -> String {
        switch self {
        case ConversionFailed(let path, let type):
            return NSString(format:NSLocalizedString("%@: Failed to convert object to type: %@.",
                comment: "Error message to show when conversion to a expected type failed."),
                            path, type) as String
        case MissingIndex(let path, let index):
            return NSString(format:NSLocalizedString("%@: Missing \"%i\" element in array.",
                comment:"Error message to show when accessing a JSON array and an expected index is not found."),
                            path, index) as String
        case MissingKey(let path, let key):
            return NSString(format:NSLocalizedString("%@: Missing \"%@\" element in dictionary.",
                comment: "Error message to show when accessing a JSON dictionary and a expected key is not found."),
                            path, key) as String
        }
    }


    public func convertToNSError() -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: self.localizedFailureReason()]
        return NSError(domain: "JSONValidationErrors", code: self._code, userInfo: userInfo)
    }

    public var description: String { get { return localizedFailureReason() }}

    public var debugDescription: String { get { return localizedFailureReason() }}
}

