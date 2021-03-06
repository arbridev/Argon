//
//  StringDateFormatter.swift
//  Argon
//
//  Created by Armando Brito on 3/15/21.
//

import Foundation

final class StringDateFormatter {
    
    /// Format a string date
    /// from: Mon May 18 2020 19:51:21 GMT-0400 (Venezuelan Standard Time)
    /// - Parameter stringDate: date as a string with the specified format
    /// - Returns: formatted date string
    static func applyFormat(stringDate: String) -> String {
        let regex = try! NSRegularExpression(pattern: #"\s\(.+\)"#, options: [])
        let mString = NSMutableString(string: stringDate)
        regex.replaceMatches(in: mString, options: [], range: NSMakeRange(0, mString.length), withTemplate: "")
        
        let regex2 = try! NSRegularExpression(pattern: #"\w{3}[+-]\d{4}"#, options: [])
        let result = regex2.firstMatch(in: String(mString), options: [], range: NSMakeRange(0, mString.length))
        mString.insert(":", at: result!.range.upperBound - 2)
        
        let dfIn = DateFormatter()
        dfIn.dateFormat = "EEEE MMM d yyyy HH:mm:ss ZZZZ"
        let date = dfIn.date(from: String(mString))
        
        let dfOut = DateFormatter()
        dfOut.dateFormat = "MMM"
        
        var formattedDate = dfOut.string(from: date!)
        
        dfOut.dateFormat = "d"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: Int(dfOut.string(from: date!))! as NSNumber)!
        
        formattedDate += " " + day
        
        return formattedDate
    }
    
    /// Format a date
    /// - Parameter date: a date
    /// - Returns: formatted date string
    static func applyFormat(date: Date) -> String {
        let dfOut = DateFormatter()
        dfOut.dateFormat = "MMM"
        
        var formattedDate = dfOut.string(from: date)
        
        dfOut.dateFormat = "d"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: Int(dfOut.string(from: date))! as NSNumber)!
        
        formattedDate += " " + day
        
        return formattedDate
    }
    
}
