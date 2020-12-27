//
//  UserRestfulServiceTest.swift
//  CodeChallengeModelTests
//
//  Created by Rohan Ramsay on 25/12/20.
//

import XCTest
import Combine
@testable import CodeChallengeModel

class UserRestfulServiceTests: XCTestCase {

    var mockRouter = MockRouter()
    var subscriptions: Set<AnyCancellable>!
    var userService: UserRestfulService!
    
    override func setUpWithError() throws {
        self.userService = UserRestfulService(router: mockRouter)
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        mockRouter.tearDown()
    }
    
    func testSuccessfulFetchNextPage() {
        mockRouter.nextResponseError = nil
        mockRouter.nextResponseOutput = (data: File.getData(name: "MockFetchUsersSuccessResponse"),
                                         response: URLResponse())
        
        let expectation = self.expectation(description: "waiting for publisher to finish")

        let pageToFetch = userService.nextPage
        let testOutput = userService.fetchNextPage()
        
        testOutput.sink(receiveCompletion: { completion in
            
            if case .failure(let error) = completion {
                XCTFail("Fetch next page API failed with error :- " + error.localizedDescription)
            }
            
            expectation.fulfill()
            
        }, receiveValue: { users in
            
            XCTAssert(users.count == 20,
                      "Fetch next page - all users not fetched")
        }).store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssert(userService.nextPage == pageToFetch + 1,
                  "Fetch next page - page number did not increment after successful fetch")
    }
    
    func testFailedDeleteUser() {
        mockRouter.nextResponseError = nil
        mockRouter.nextResponseOutput = (data: File.getData(name: "MockDeleteUserFailureResponse"),
                                         response: URLResponse())
        
        let expectation = self.expectation(description: "waiting for publisher to finish")

        let testOutput = userService.delete(user: User(name: "", email: "", gender: .female, status: .active, createdOn: Date()))
        
        testOutput.sink(receiveCompletion: { completion in
            
            if case .failure(let error) = completion {
                
                if case .network = error {
                    XCTFail("Delete user failure - wrong error type")
                }
                
                if case .server(let message) = error {
                    XCTAssert(message == "Resource not found", "Delete user failure - proper error message from server not getting through")
                }
            }
            
            if case .finished = completion {
                XCTFail("Delete user failed operation not returning error")
            }
            
            expectation.fulfill()
            
        }, receiveValue: { _ in          
        }).store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }

    func testSuccessfulCreateUser() {
        mockRouter.nextResponseError = nil
        mockRouter.nextResponseOutput = (data: File.getData(name: "MockCreateUserSuccessResponse"),
                                         response: URLResponse())
        
        let expectation = self.expectation(description: "waiting for publisher to finish")

        let testOutput = userService.add(user: User(name: "", email: "", gender: .female, status: .active, createdOn: Date())) //this user does not matter - compare against the one in the response
        var addedUser: User? = nil
        
        testOutput.sink(receiveCompletion: { completion in
            
            if case .failure(let error) = completion {
                XCTFail("Add user API failed with error :- " + error.localizedDescription)
            }
            
            expectation.fulfill()
            
        }, receiveValue: { user in
            addedUser = user
        }).store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(addedUser, "Add user API :- User not returned")
        XCTAssert(addedUser!.id == 1513, "Add user :- incorrect data in added user")
    }
}
