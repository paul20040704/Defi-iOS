//
//  PurchaseUITests.swift
//  DefiAPPUITests
//
//  Created by 彥甫陳 on 2023/12/19.
//

import XCTest

final class PurchaseUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //理財測試
    func testPurchase() {
        let table = app.tables.element
        let firstCell = table.cells.element(boundBy: 3)
        firstCell.tap()
        
        let purchaseButton = app.buttons["申購"]
        XCTAssertTrue(purchaseButton.exists, "申購 Button 不存在")
        purchaseButton.tap()
        
        XCTAssertTrue(app.navigationBars["申購"].exists)
        
        let backButton = app.buttons["Back"]
        backButton.tap()
        
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
