//
//  GithubUsersTests.swift
//  GithubUsersTests
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import XCTest
@testable import GithubUsers

final class GithubUsersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsersAPI() {
        
        guard let url = UsersRouter.getUsers(queryItems: [URLQueryItem(name: UsersModel.RequestTags.since.rawValue, value: "0")]).getURLRequest().url, let mockedURL = URL(string: "https://api.github.com/users?since=0") else {
            
            XCTFail("Invalid URL")
            return
        }
        
        XCTAssertEqual(url, mockedURL)
        
        let jsonData = FileUtil.data(for: "users.json")!
        let preFetchedUsers = DataParser.parseUsers(data: jsonData)
        
        let expectation = XCTestExpectation(description: "Fetching users")
        URLProtocolMock.testURLs = [url: jsonData]
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        MockedUsersModel.getUsers(url: url, using: session) { result in
            switch result {
            case .success(let users):
                
                XCTAssertEqual(users, preFetchedUsers)
                
            case .failure:
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUserProfileAPI() {
        
        guard let url = UsersRouter.getUserProfile(userName: "tawk").getURLRequest().url, let mockedURL = URL(string: "https://api.github.com/users/tawk") else {
            
            XCTFail("Invalid URL")
            return
        }
        
        XCTAssertEqual(url, mockedURL)
        
        let jsonData = FileUtil.data(for: "userProfile.json")!
        let preFetchedUserProfile = DataParser.parseUserProfile(data: jsonData)
        
        let expectation = XCTestExpectation(description: "Fetching user profile")
        URLProtocolMock.testURLs = [url: jsonData]
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        MockedUsersModel.getUserProfile(url: url, using: session) { result in
            switch result {
            case .success(let user):
                
                XCTAssertEqual(user, preFetchedUserProfile)
                
            case .failure:
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testCoreData() {
        
        let coreDataStack = TestCoreDataStack()
        let context = coreDataStack.persistentContainer.newBackgroundContext()
        
        var user = User()
        user.id = 0000000000
        coreDataStack.createNewUserEntity(for: user, with: context)
        
        expectation(forNotification: .NSManagedObjectContextDidSave,
                    object: context) { _ in
            
            let user = coreDataStack.fetchUser(with: user.id, for: context)
            
            
            XCTAssertNotNil(user)
            
            return true
        }
        
        try? context.save()
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testCoreDataUpdating() {
        
        let coreDataStack = TestCoreDataStack()
        let context = coreDataStack.persistentContainer.newBackgroundContext()
        
        let userName = "Test"
        
        var user = User()
        user.id = 0000000000
        user.name = userName
        
        expectation(forNotification: .NSManagedObjectContextDidSave,
                    object: context) { _ in
            
            let user = coreDataStack.fetchUser(with: user.id, for: context)
            
            XCTAssertNotNil(user)
            XCTAssertEqual(user?.name, userName)
            
            return true
        }
        
        coreDataStack.updateUser(user, for: context)
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
