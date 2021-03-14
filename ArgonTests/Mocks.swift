//
//  Mocks.swift
//  ArgonTests
//
//  Created by Armando Brito on 3/14/21.
//

import Foundation
@testable import Argon

struct Mocks {
    static let user = User(uid: "000",
                           name: "Test",
                           email: "test@test.com",
                           profilePic: "some.png",
                           posts: [Mocks.post1])
    
    static let post1 = Post(id: 0,
                           date: "Mon May 17 2020 18:57:28 GMT-0400 (Venezuela Standard Time)",
                           pics: ["https://www.positive.news/wp-content/uploads/2019/03/feat-1800x0-c-center.jpg"])
    static let post2 = Post(id: 1,
                           date: "Mon May 18 2020 19:51:21 GMT-0400 (Venezuela Standard Time)",
                           pics: ["https://pi.tedcdn.com/r/talkstar-assets.s3.amazonaws.com/production/playlists/playlist_359/Extreme_sports_1200x627.jpg?quality=89&w=800"])
}
