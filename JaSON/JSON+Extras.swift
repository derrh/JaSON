
import Foundation

extension Float : JSONValueType {}
extension Double : JSONValueType {}

extension Dictionary where Key: JSONKeyType {
    
    static func JSONObjectWithData(data:NSData) throws -> [Key:Value] {
        let obj:Any = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        return try self.JSONValue(obj)
    }
    
    public func rawData() throws -> NSData {
        guard let dict = self as? AnyObject else {
            throw JSONError.TypeMismatch
        }
        return try NSJSONSerialization.dataWithJSONObject(dict, options: [])
    }
    
    
    static func JSONObjectArrayWithData(data:NSData) throws -> [JSONObject] {
        let obj:AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        guard let ra = obj as? [JSONObject] else {
            throw JSONError.TypeMismatch
        }
        return ra
    }
    
}

extension NSDate : JSONValueType {
    public static func JSONValue(object: Any) throws -> NSDate {
        if let dateString = object as? String,
            date = NSDate.fromISO8601String(dateString) {
                return date
        }
        throw JSONError.TypeMismatch
    }
}

extension NSDate {
    static private let ISO8601Formatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'";
        let tz = NSTimeZone(abbreviation:"GMT")
        formatter.timeZone = tz
        return formatter
        }()
    
    static func fromISO8601String(dateString:String) -> NSDate? {
        return ISO8601Formatter.dateFromString(dateString)
    }
}

extension NSURL : JSONValueType {
    public static func JSONValue(object: Any) throws -> NSURL {
        if let urlString = object as? String,
            url = NSURL(string: urlString) {
                return url
        }
        throw JSONError.TypeMismatch
    }
}
