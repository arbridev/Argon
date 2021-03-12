//
//  AppData.swift
//  Argon
//
//  Created by Armando Brito on 3/11/21.
//

import Foundation

// MARK: - AppData
struct AppData: Codable {
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "data"
    }
}
