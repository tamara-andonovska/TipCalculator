//
//  ScreenIdentifier.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/4/24.
//

import Foundation
// Has to be added to the main and UI test target - constants will be used by both.

enum ScreenIdentifier {
    enum LogoView: String {
        case logoViewIcon
    }

    enum ResultView: String {
        case totalAmountPerPersonValueLabel
        case totalBillValueLabel
        case totalTipValueLabel
    }
    
    enum BillInputView: String {
        case textField
    }
    
    enum TipInputView: String {
        case tenPercentButton
        case fifteenPercentButton
        case twentyPercentButton
        case customTipButton
        case customTipAlertTextField
    }
    
    enum SplitInputView: String {
        case decrementButton
        case incrementButton
        case quantityValueLabel
    }
}
