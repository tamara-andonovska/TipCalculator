//
//  Double+Extensions.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/5/24.
//

import Foundation

extension Double {
    var currencyFormatted: String {
        var isNormalNumber: Bool { isNormal ? self == rounded() : false }
        var isWholeNumber: Bool { isZero ? true : isNormalNumber }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? "$0"
    }
}
