//
//  CodeChallenge1AllNativeTests.swift
//  CodeChallenge1AllNativeTests
//
//  Created by Rohan Ramsay on 17/12/20.
//

import XCTest
import Combine
@testable import CodeChallenge1AllNative
@testable import CodeChallengeModel

class UserListViewModelTests: XCTestCase {

    var viewModel: UserListViewModel!
    var mockRepo: MockUserRepository!
    var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockRepo = MockUserRepository()
        viewModel = UserListViewModel(repository: mockRepo)
        subscriptions = Set<AnyCancellable>()
    }

    func test_successfulAddUser() {
        let userCountBeforeAdd = viewModel.users.count
        let expectationUserUpdates = XCTestExpectation(description: "waiting for user publisher to return")
        let expectationInprogressActivityUpdates = XCTestExpectation(description: "waiting for activity publisher to return")
        expectationUserUpdates.expectedFulfillmentCount = 2 //initial & after add
        expectationInprogressActivityUpdates.expectedFulfillmentCount = 3 //initial, during add, after add

        let expectedInprogressUpdates = [false, true, false]
        var observedInprogressUpdates = [Bool]()
        
        viewModel.$users.receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectationUserUpdates.fulfill()
            }).store(in: &subscriptions)
        
        viewModel.$activityInprogress.receive(on: DispatchQueue.main)
            .sink(receiveValue: { inprogressState in
                observedInprogressUpdates.append(inprogressState)
                expectationInprogressActivityUpdates.fulfill()
            }).store(in: &subscriptions)
        
        viewModel.add(user: User(name: "", email: "", gender: .female, status: .active, createdOn: Date()))

        wait(for: [expectationUserUpdates, expectationInprogressActivityUpdates], timeout: 1)
        
        XCTAssert(viewModel.users.count == userCountBeforeAdd + 1, "Add user failure :- user count not increased")
        XCTAssertEqual(expectedInprogressUpdates, observedInprogressUpdates, "Add user failure :- ActivityInprogress did not fire expected updates")
    }
    
    func test_failedDeleteUser() {
        let userCountBeforeAdd = viewModel.users.count
        let expectationUserUpdates = XCTestExpectation(description: "waiting for user publisher to return")
        let expectationInprogressActivityUpdates = XCTestExpectation(description: "waiting for activity publisher to return")
        let expectationError = XCTestExpectation(description: "waiting for error publisher to fire update")
        expectationUserUpdates.expectedFulfillmentCount = 1 //initial
        expectationInprogressActivityUpdates.expectedFulfillmentCount = 3 //initial, during delete, after delete
        expectationError.expectedFulfillmentCount = 1
        
        let expectedInprogressUpdates = [false, true, false]
        var observedInprogressUpdates = [Bool]()
        
        viewModel.$users.receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectationUserUpdates.fulfill()
            }).store(in: &subscriptions)
        
        viewModel.$activityInprogress.receive(on: DispatchQueue.main)
            .sink(receiveValue: { inprogressState in
                observedInprogressUpdates.append(inprogressState)
                expectationInprogressActivityUpdates.fulfill()
            }).store(in: &subscriptions)
        
        var errorMessage = ""
        var errorTitle = ""

        viewModel.errorPublisher.sink(receiveValue: {error in
            errorMessage = error.message
            errorTitle = error.title ?? ""
            expectationError.fulfill()
        }).store(in: &subscriptions)
        
        mockRepo.nextOperationError = .network
        viewModel.delete(user: User(name: "", email: "", gender: .female, status: .active, createdOn: Date()))
        
        wait(for: [expectationUserUpdates, expectationInprogressActivityUpdates], timeout: 1)

        XCTAssert(viewModel.users.count == userCountBeforeAdd, "Delete user failure :- user count not consistent")
        XCTAssertEqual(expectedInprogressUpdates, observedInprogressUpdates, "Delete user failure :- ActivityInprogress did not fire expected updates")

        XCTAssertEqual(errorTitle, "Could not delete user", "Delete user failure :- Expected error title not received")
        XCTAssertEqual(errorMessage, "Something went wrong. Check your Internet connection and try again.", "Delete user failure :- Expected error title not received")

    }

}
