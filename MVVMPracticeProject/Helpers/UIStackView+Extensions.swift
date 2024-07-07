//
//  UIStackView+Extensions.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/1/24.
//

import UIKit

extension UIStackView {
    static func create(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        distribution: Distribution = .fill,
        alignment: Alignment = .fill,
        arrangedSubviews: [UIView]
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
