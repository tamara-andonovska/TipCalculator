//
//  NSAttributedString+Extensions.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/5/24.
//

import Foundation
import UIKit

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    static func font(_ font: UIFont) -> Self {
        [.font: font]
    }
}
