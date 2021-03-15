//
//  Post+Mapping.swift
//  Argon
//
//  Created by Armando Brito on 3/14/21.
//

import Foundation
import CouchbaseLiteSwift

extension Post {
    
    static func map(from dict: DictionaryObject, id: String) -> Post {
        guard let date = dict.string(forKey: "date"),
              let pics = dict.array(forKey: "pics")?.toArray() as? [String] else {
            fatalError("Could not map \(self.self)")
        }
        return Post(id: Int(id)!, date: date, pics: pics)
    }
    
    static func map(from doc: Document) -> Post {
        guard let date = doc.string(forKey: "date"),
              let pics = doc.array(forKey: "pics")?.toArray() as? [String] else {
            fatalError("Could not map \(self.self)")
        }
        return Post(id: Int(doc.id)!, date: date, pics: pics)
    }
    
}
