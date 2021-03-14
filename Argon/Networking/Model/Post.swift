//
//  Post.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let id: Int
    let date: String
    let pics: [String]
}
