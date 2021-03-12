//
//  User.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import Foundation

// MARK: - User
struct User: Codable {
    let uid, name, email: String
    let profilePic: String
    let posts: [Post]

    enum CodingKeys: String, CodingKey {
        case uid, name, email
        case profilePic = "profile_pic"
        case posts
    }
}
