//
//  ArgonTests.swift
//  ArgonTests
//
//  Created by Armando Brito on 3/11/21.
//

import XCTest
@testable import Argon

class ArgonTests: XCTestCase {
    
    let network = NetworkManager()
    var persistence: PersistenceManager!
    
    override func setUp() {
        persistence = PersistenceManager(databaseName: "testdb")
        sleep(2)
    }
    
    override func tearDown() {
        sleep(2)
        persistence.removeDatabase()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworking() throws {
        let dataExp = self.expectation(description: "fetch data")
        
        network.getAppData { (appData) in
            XCTAssert(appData != nil)
            dataExp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPersistenceOfUsers() throws {
        let user = Mocks.user
        persistence.add(user: user)
        sleep(2)
        XCTAssert(persistence.getUsersCount() > 0)
        let newEmail = "new@email.com"
        let modUser = User(uid: user.uid, name: user.name, email: newEmail, profilePic: user.profilePic, posts: user.posts)
        persistence.update(user: modUser)
        sleep(2)
        let updatedUser = persistence.getUser(withUID: user.uid)
        XCTAssert(updatedUser != nil)
        XCTAssert(updatedUser!.email == newEmail)
        persistence.remove(userWithUID: user.uid)
        sleep(2)
        XCTAssert(persistence.getUsersCount() == 0)
    }
    
    func testPersistenceOfPosts() throws {
        let user = Mocks.user
        persistence.add(user: user)
        sleep(2)
        let initPostCount = persistence.getPostsCount()
        let post = Mocks.post2
        persistence.add(post: post, toUserWithUID: user.uid)
        sleep(2)
        let midPostCount = persistence.getPostsCount()
        XCTAssert(midPostCount > initPostCount)
        let newDate = "Mon May 18 2020 19:51:21 GMT-0400 (Venezuela Standard Time)"
        let modPost = Post(id: post.id, date: newDate, pics: post.pics)
        persistence.update(post: modPost)
        sleep(2)
        let updatedPost = persistence.getPost(withID: "\(post.id)")
        XCTAssert(updatedPost != nil)
        XCTAssert(updatedPost!.date == newDate)
        persistence.remove(postWithID: "\(post.id)")
        sleep(2)
        let endPostCount = persistence.getPostsCount()
        XCTAssert(endPostCount == initPostCount)
    }
    
    func testNetworkPersistence() throws {
        let dataExp = self.expectation(description: "fetch data")
        
        network.getAppData { (appData) in
            XCTAssert(appData != nil)
            guard let appData = appData else {
                return
            }
            self.persistence.add(user: appData.users[0])
            dataExp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let usersCount = persistence.getUsersCount()
        XCTAssert(usersCount > 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
