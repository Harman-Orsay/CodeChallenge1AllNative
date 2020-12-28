//
//  UserListUITests.swift
//  CodeChallenge1AllNativeUITests
//
//  Created by Rohan Ramsay on 28/12/20.
//

import XCTest

class UserListUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        app = XCUIApplication()
        app.launch()
    }

   
    func test_userListActionSheet() {
        let bulletestListIndentButton = app.navigationBars["Users"].buttons["bulletest list indent"]
        XCTAssert(bulletestListIndentButton.exists, "List actions button not present")
        
        bulletestListIndentButton.tap()
        let listActionSheet = app.sheets["List Actions"]
        XCTAssert(listActionSheet.exists, "List action sheet not displayed")
        
        let elementsQuery = listActionSheet.scrollViews.otherElements
        XCTAssert(elementsQuery.buttons["Sort Users"].exists, "Sort user action not displayed")
        XCTAssert(elementsQuery.buttons["Delete Users"].exists, "Sort user action not displayed")

        let deleteButton = elementsQuery.buttons["Delete Users"]
        deleteButton.tap()
        XCTAssertFalse(listActionSheet.exists, "List action sheet not removed on delete user action selection")
    }
}
