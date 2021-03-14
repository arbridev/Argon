//
//  UserMapper.swift
//  Argon
//
//  Created by Armando Brito on 3/13/21.
//

import Foundation
import CouchbaseLiteSwift

extension User {
    
    static func map(from dict: DictionaryObject) -> User {
        guard let uid = dict.string(forKey: "id"),
              let name = dict.string(forKey: "name"),
              let email = dict.string(forKey: "email"),
              let profilePic = dict.string(forKey: "profilePic") else {
            fatalError("Could not map \(self.self)")
        }
        return User(uid: uid, name: name, email: email, profilePic: profilePic, posts: [Post]())
    }
    
    static func map(from doc: Document) -> User {
        guard let name = doc.string(forKey: "name"),
              let email = doc.string(forKey: "email"),
              let profilePic = doc.string(forKey: "profilePic") else {
            fatalError("Could not map \(self.self)")
        }
        return User(uid: doc.id, name: name, email: email, profilePic: profilePic, posts: [Post]())
    }
    
}
