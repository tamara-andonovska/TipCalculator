//
//  Tip.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/2/24.
//

import Foundation

public enum Tip {
    case none
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case custom(value: Int)
    
    var description: String {
        switch self {
        case .none: ""
        case .tenPercent: "10%"
        case .fifteenPercent: "15%"
        case .twentyPercent: "20%"
        case .custom(let value): String(value)
        }
    }
}
