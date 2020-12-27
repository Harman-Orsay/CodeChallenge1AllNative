//
//  UserDataRepositoryTests.swift
//  CodeChallengeModelTests
//
//  Created by Rohan Ramsay on 27/12/20.
//

import XCTest
import Combine
@testable import CodeChallengeModel

class UserDataRepositoryTests: XCTestCase {
    
    var mockService = MockUserService()
    var subscriptions: Set<AnyCancellable>!
    var userRepo: UserDataRepository!

    override func setUpWithError() throws {
        userRepo = UserDataRepository(service: mockService)
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        mockService.tearDown()
    }

    func testSuccessfulGetMoreUsers() {
        var expectedUsers = [User]()
        
        let expectation1 = self.expectation(description: "waiting for get more users to finish")
        let expectation2 = self.expectation(description: "waiting for user to update")
        expectation2.expectedFulfillmentCount = 2 //one when subscribed, one when it updates

        userRepo.users.sink(receiveValue: {
            users in
            expectedUsers.append(contentsOf: users)
            expectation2.fulfill()
        }).store(in: &subscriptions)
        
        userRepo.getMore().sink(receiveCompletion: {
            completion in
            if case .failure(_) = completion {
                XCTFail("User repo :- Failed with error")
            }
            expectation1.fulfill()
            
        }, receiveValue: {})
        .store(in: &subscriptions)
    
        wait(for: [expectation1, expectation2], timeout: 1)
        
        XCTAssert(expectedUsers.count == 20, "User repo :- Get more users did not return the expected number of users")
    }
    
    func testNetworkFailedDeleteUser() {
        var expectedUsers = [User]()
        
        let expectation1 = self.expectation(description: "waiting for delete user to finish")
        let expectation2 = self.expectation(description: "waiting for user to update")
        expectation2.expectedFulfillmentCount = 1 //one when subscribed, it should not update
        
        userRepo.users.sink(receiveValue: {
            users in
            expectedUsers.append(contentsOf: users)
            expectation2.fulfill()
        }).store(in: &subscriptions)
        
        mockService.failNextWithError = .network
        
        userRepo.delete(user: User(id: 90, name: "", email: "", gender: .female, status: .active, lastUpdated: Date()))
            .sink(receiveCompletion: {
                completion in
                if case .finished = completion {
                    XCTFail("User repo delete user not returning the error")
                }
                
                if case .failure(let error) = completion {
                    if case .server(_) = error {
                        XCTFail("User repo delete user not returning the correct error type")
                    }
                }
                
                expectation1.fulfill()
                
            }, receiveValue: {})
            .store(in: &subscriptions)
        
        wait(for: [expectation1, expectation2], timeout: 1)
    }
}
