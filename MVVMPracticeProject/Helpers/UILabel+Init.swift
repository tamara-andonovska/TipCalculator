//
//  UILabel+Init.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import Foundation
import UIKit

extension UILabel {
    static func create(
        text: String?,
        font: UIFont?,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .primaryText,
        alignment: NSTextAlignment = .center
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = alignment
        return label
    }
}
