//
//  Post.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let id, date: Int
    let pics: [String]
}
