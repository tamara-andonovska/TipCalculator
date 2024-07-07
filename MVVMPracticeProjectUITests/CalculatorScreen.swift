//
//  CalculatorScreen.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/4/24.
//

import Foundation
import XCTest
import MVVMPracticeProject
// Only exposed/added to UI test target.

class CalculatorScreen {
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
}

// MARK: - View -

extension CalculatorScreen {
    // MARK: - LogoView -
    
    var logoViewIcon: XCUIElement {
        app.otherElements[ScreenIdentifier.LogoView.logoViewIcon.rawValue]
    }
    
    // MARK: - ResultView -
    
    var totalAmountPerPersonValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue]
    }
    
    var totalBillValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalBillValueLabel.rawValue]
    }
    
    var totalTipValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalTipValueLabel.rawValue]
    }

    // MARK: - BillInputView -
    
    var billInputTextField: XCUIElement {
        app.textFields[ScreenIdentifier.BillInputView.textField.rawValue]
    }
    
    // MARK: - TipInputView -
    
    var tenPercentButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.tenPercentButton.rawValue]
    }
    
    var fifteenPercentButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.fifteenPercentButton.rawValue]
    }
    
    var twentyPercentButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.twentyPercentButton.rawValue]
    }
    
    var customTipButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.customTipButton.rawValue]
    }
    
    var customTipAlertTextField: XCUIElement {
        app.textFields[ScreenIdentifier.TipInputView.customTipAlertTextField.rawValue]
    }
    
    // MARK: - SplitInputView -
    
    var incrementButton: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.incrementButton.rawValue]
    }
    
    var decrementButton: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.decrementButton.rawValue]
    }
    
    var quantityValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.SplitInputView.quantityValueLabel.rawValue]
    }
}

// MARK: - Actions -

extension CalculatorScreen {
    func enterBill(amount: Double) {
        billInputTextField.tap()
        billInputTextField.typeText("\(amount)\n") // \n is used for dismissing keyboard
    }
    
    func selectTip(tip: Tip) {
        switch tip {
        case .none: break
        case .tenPercent: tenPercentButton.tap()
        case .fifteenPercent: fifteenPercentButton.tap()
        case .twentyPercent: twentyPercentButton.tap()
        case .custom(let value):
            customTipButton.tap()
            XCTAssertTrue(customTipAlertTextField.waitForExistence(timeout: 1.0))
            customTipAlertTextField.typeText("\(value)\n")
        }
    }
    
    func tapIncrementButton(numberOfTaps: Int) {
        incrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
        // Number of taps - the number of taps required to execute the action (eg. single tap, double-tap)
        // Number of touches - the number of times we "activate"
    }
    
    func tapDecrementButton(numberOfTaps: Int) {
        decrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func tapLogo() {
        logoViewIcon.tap()
    }
}
