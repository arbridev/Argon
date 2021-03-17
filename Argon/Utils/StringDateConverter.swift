//
//  StringDateConverter.swift
//  Argon
//
//  Created by Armando Brito on 3/16/21.
//

import Foundation

final class StringDateConverter {
    
    /// Format a string date
    /// from: Mon May 18 2020 19:51:21 GMT-0400 (Venezuelan Standard Time)
    /// - Parameter stringDate: date as a string with the specified format
    /// - Returns: formatted date
    static func convert(_ stringDate: String) -> Date? {
        let regex = try! NSRegularExpression(pattern: #"\s\(.+\)"#, options: [])
        let mString = NSMutableString(string: stringDate)
        regex.replaceMatches(in: mString, options: [], range: NSMakeRange(0, mString.length), withTemplate: "")
        
        let regex2 = try! NSRegularExpression(pattern: #"\w{3}[+-]\d{4}"#, options: [])
        let result = regex2.firstMatch(in: String(mString), options: [], range: NSMakeRange(0, mString.length))
        mString.insert(":", at: result!.range.upperBound - 2)
        
        let dfIn = DateFormatter()
        dfIn.dateFormat = "EEEE MMM d yyyy HH:mm:ss ZZZZ"
        let date = dfIn.date(from: String(mString))
        return date
    }
    
}
