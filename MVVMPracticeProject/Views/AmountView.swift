//
//  AmountView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/1/24.
//

import UIKit

class AmountView: UIView {
    
    // MARK: - Private properties -
    
    private let title: String
    private let alignment: NSTextAlignment
    private let amountIdentifier: ScreenIdentifier.ResultView
    
    // MARK: - Lifecycle -
    
    init(title: String, alignment: NSTextAlignment, amountIdentifier: ScreenIdentifier.ResultView) {
        self.title = title
        self.alignment = alignment
        self.amountIdentifier = amountIdentifier
        super.init(frame: .zero) // This is fine to be zero since we will use autolayout.
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views -
    
    /// lazy variable:
    /// These variables are created using a function you specify only when that variable is first requested.
    /// If it's never requested, the function is never run, so it does help save processing time.
    /// https://www.hackingwithswift.com/example-code/language/what-are-lazy-variables
    /// Therefore, you don't have to avoid lazy vars.
    private lazy var titleLabel = UILabel.create(
        text: title,
        font: .regular(ofSize: 18),
        textColor: .primaryText,
        alignment: alignment
    )
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = alignment
        label.textColor = .primaryText
        label.attributedText = Self.amountAttributedString(for: "$0")
        
        label.accessibilityIdentifier = amountIdentifier.rawValue
        
        return label
    }()
    
    private lazy var stackView = UIStackView.create(
        axis: .vertical,
        spacing: 4,
        arrangedSubviews: [titleLabel, amountLabel]
    )
}

extension AmountView {
    func configure(amount: Double) {
        amountLabel.attributedText = Self.amountAttributedString(for: amount.currencyFormatted)
    }
}

private extension AmountView {
    func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview() // edges == top, bottom, leading, trailing
        }
    }
    
    static func amountAttributedString(for string: String) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(
            string: string,
            attributes: .font(.bold(ofSize: 24))
        )
        text.addAttributes(
            .font(.bold(ofSize: 16)),
            range: .init(location: 0, length: 1) // Start at zero, till 1, so apply to the first char i.e. at index 0
        )
        return text
    }
}
