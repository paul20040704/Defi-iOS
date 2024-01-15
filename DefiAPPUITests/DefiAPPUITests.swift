//
//  DefiAPPUITests.swift
//  DefiAPPUITests
//
//  Created by 彥甫陳 on 2023/10/30.
//

import XCTest

final class DefiAPPUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
     
        let emailTextField = app.textFields["emailTF"]
        XCTAssertTrue(emailTextField.exists, "電子信箱 TextField 不存在")
        
        emailTextField.tap()
        emailTextField.clearText()
        emailTextField.typeText("paul20040704@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["passwordTF"]
        XCTAssertTrue(passwordSecureTextField.exists, "密碼 SecureTextField 不存在")

        // 清除密碼 SecureTextField 並輸入密碼
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Aa123456@")

        let loginButton = app.buttons["loginButton"]
        XCTAssertTrue(loginButton.exists, "登入 Button 不存在")

        app.tap()
        // 點擊登入 Button
        loginButton.tap()
                
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
