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
    
    func testPersistence() throws {
        let user = User(uid: "000", name: "Test", email: "test@test.com", profilePic: "some.png", posts: [Post]())
        persistence.add(user: user)
        sleep(2)
        XCTAssert(persistence.getUsersCount() > 0)
        persistence.remove(userWithUID: user.uid)
        sleep(2)
        XCTAssert(persistence.getUsersCount() == 0)
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
