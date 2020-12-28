//
//  UserServiceEndpointTests.swift
//  CodeChallengeModelTests
//
//  Created by Rohan Ramsay on 27/12/20.
//

import XCTest
@testable import CodeChallengeModel

class UserServiceEndpointTests: XCTestCase {

    func testAddUserEndpoint() {
        let createUserUrlReq = UserRestfulService.Endpoint.create(user: UserDTO(id: nil, createdAt: nil, updatedAt: nil, email: "zzz@zz.zz", gender: "Male", name: "xxx", status: "Active")).urlRequest
        let expectedUrlReq = StubUserServiceEndpoint.createUser.urlRequest
        
        XCTAssertNotNil(createUserUrlReq?.url, "Add user endpoint did not produce url")
        XCTAssert(createUserUrlReq!.url == expectedUrlReq.url, "Add user endpoint did not produce expected url")
        XCTAssert(createUserUrlReq!.httpMethod == expectedUrlReq.httpMethod, "Add user endpoint did not have expected http method")
        
        let payload = try! JSONSerialization.jsonObject(with: createUserUrlReq!.httpBody!, options: .allowFragments) as! [String: String]
        let expectedPayload = try! JSONSerialization.jsonObject(with: expectedUrlReq.httpBody!, options: .allowFragments) as! [String: String]
        
        XCTAssert(payload["email"] == expectedPayload["email"], "Add user endpoint :- incorrect email in payload")
        XCTAssert(payload["name"] == expectedPayload["name"], "Add user endpoint :- incorrect name in payload")
        XCTAssert(payload["gender"] == expectedPayload["gender"], "Add user endpoint :- incorrect gender in payload")
        XCTAssert(payload["status"] == expectedPayload["status"], "Add user endpoint :- incorrect gender in payload")
    }
}

