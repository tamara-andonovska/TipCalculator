//
//  MVVMPracticeProjectUITests.swift
//  MVVMPracticeProjectUITests
//
//  Created by Tamara Andonovska on 6/1/24.
//

import XCTest

final class MVVMPracticeProjectUITests: XCTestCase {
    private var app: XCUIApplication! // We need to have the app
    private var screen: CalculatorScreen { // We need to have the screen we will be testing
        .init(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testResultViewDefaultValues() {
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$0")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
    }
    
    func testRegularTips() {
        // 10/15/20% tips
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        screen.selectTip(tip: .tenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$110")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$110")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$10")
        
        screen.selectTip(tip: .fifteenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$115")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$115")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$15")
        
        screen.selectTip(tip: .twentyPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$120")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")
    }
    
    func testRegularTipsFor4and2People() {
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        screen.tapIncrementButton(numberOfTaps: 3)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$25")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        screen.tapDecrementButton(numberOfTaps: 2)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$50")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
    }
    
    func testCustomTip() {
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        screen.selectTip(tip: .custom(value: 100))
        
        screen.tapIncrementButton(numberOfTaps: 1) // 2 people
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$200")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$100")
        
        screen.tapIncrementButton(numberOfTaps: 2) // 4 people
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$50")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$200")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$100")
    }
    
    func testResetButton() {
        screen.enterBill(amount: 100)
        screen.tapIncrementButton(numberOfTaps: 1)
        screen.selectTip(tip: .custom(value: 100))
        
        screen.tapLogo()
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$0")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        XCTAssertEqual(screen.billInputTextField.label, "")
        XCTAssertEqual(screen.customTipButton.label, "Custom tip")
        XCTAssertEqual(screen.quantityValueLabel.label, "1")
    }
}
