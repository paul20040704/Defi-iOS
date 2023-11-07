//
//  DefiAPPTests.swift
//  DefiAPPTests
//
//  Created by 彥甫陳 on 2023/10/30.
//

import XCTest
@testable import DefiAPP

final class DefiAPPTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBase64Decode() throws {
        let globalFunc = GlobalFunc.shared
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoicGF1bDIwMDQwNzA0QGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2F1dGhlbnRpY2F0aW9uIjoiZjQ0NTVkOWUtYTY1Mi00NmM5LTk2ODUtNmY5OWRiYjA2NGM2IiwibmFtZSI6InBhdWwyMDA0MDcwNEBnbWFpbC5jb20iLCJlbWFpbCI6InBhdWwyMDA0MDcwNEBnbWFpbC5jb20iLCJqdGkiOiJwYXVsMjAwNDA3MDRAZ21haWwuY29tIiwiZXhwIjoxNjk5NDIzMjczLCJpc3MiOiJpcndhLmlvIiwiYXVkIjoiaXJ3YS5pbyJ9.zbSX3KgaTpOflKYGObYi6aGN7ZrqnmrUfhLtJxzT5Sc"
        
        if let expiration = globalFunc.decodeToken(token: token) {
            XCTAssertEqual(expiration, 1699423273)
        }else {
            XCTFail("解码失败")
        }
    }
    
    func testEmail() throws {
        XCTAssertTrue("test@email".validateEmail())
        XCTAssertTrue("testemail".validateEmail())
        XCTAssertTrue("test@email.com".validateEmail())
    }
    
    func testPassword() throws {
        XCTAssertTrue("aa123456".validatePassword())
        XCTAssertTrue("12345678".validatePassword())
        XCTAssertTrue("Aa123456".validatePassword())
        XCTAssertTrue("Aa123456!".validatePassword())
        XCTAssertTrue("Aa12345".validatePassword())
    }
    
    //測試預期收到
    func testExpect() throws {
        let product = ProductData(id: "", apr: 10, asset: "", chain: "", lDs: 0, maximumAmount: 2000, minumumAmount: 10000, period: Period(length: 0, unit: ""), subscriptionEndDate: "", subscriptionStartDate: "", hasBegun: true, hasEnded: true, isPurchaseable: true, isExpired: true)
        let viewModel = PurchaseDetailViewModel(productData: product)
        viewModel.amount = 2000
        let result = viewModel.expectAmount(monthType: 0)
        XCTAssertEqual(result, "16.667")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
