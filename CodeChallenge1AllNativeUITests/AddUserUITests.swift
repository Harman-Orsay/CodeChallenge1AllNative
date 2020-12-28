//
//  AddUserUITests.swift
//  CodeChallenge1AllNativeUITests
//
//  Created by Rohan Ramsay on 28/12/20.
//

import XCTest

class AddUserUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        app = XCUIApplication()
        app.launch()
        app.navigationBars["Users"].buttons["Add"].tap()
    }

 
    func test_nameEntryErrorDisplay() {
        XCTAssert(app.staticTexts["Name cannot be empty"].exists, "Initial empty name error not displayed")
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("a")
        XCTAssertFalse(app.staticTexts["Name cannot be empty"].exists, "Empty name error displayed after name has recived a character")
    
        app.keyboards.keys["delete"].tap()
        XCTAssert(app.staticTexts["Name cannot be empty"].exists, "Empty name error not displayed after deleting charcaters")
        
        nameTextField.typeText("   ")
        XCTAssert(app.staticTexts["Name cannot be empty"].exists, "Empty name error not displayed after entering empty space charcaters")
    }
    
    func test_emailEntryErrors() {
        let nameTextField = app.textFields["Name"]
        let emailTextField = app.textFields["Email"]
        nameTextField.tap()
        nameTextField.typeText("abc")
        XCTAssert(app.staticTexts["Email cannot be empty"].exists, "Initial empty email error not displayed after name was typed")
        
        emailTextField.tap()
        emailTextField.typeText("a")
        XCTAssertFalse(app.staticTexts["Email cannot be empty"].exists, "Empty email error displayed after email has recived a character")
        XCTAssert(app.staticTexts["Malformed Email"].exists, "Malformed email error not displayed after partial email was typed - single chanracter entered")

        app.keyboards.keys["delete"].tap()
        XCTAssert(app.staticTexts["Email cannot be empty"].exists, "Empty email error not displayed after deleting characters")

        emailTextField.typeText("abc@abc")
        XCTAssert(app.staticTexts["Malformed Email"].exists, "Malformed email error not displayed after partial email was typed - domain not provided")
        
        emailTextField.typeText(".com")
        XCTAssertFalse(app.staticTexts["Email cannot be empty"].exists, "Empty email error displayed after full email entered")
        XCTAssertFalse(app.staticTexts["Malformed Email"].exists, "Malformed email error displayed after full email entered")
    }
}
