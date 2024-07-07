//
//  ResultView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import Foundation
import UIKit
import SnapKit

class ResultView: UIView {
    
    // MARK: - Views -
    
    private let headerLabel = UILabel.create(
        text: .Result.totalPerPerson,
        font: .demiBold(ofSize: 18)
    )
    
    private let amountPerPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = amountPerPersonAttributedString(for: "$0")
        
        label.accessibilityIdentifier = ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue
        
        return label
    }()
    
    private let horizontalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    /// Lazy var is used when we are accessing properties the init runs, i.e. self (where the properties are) becomes available.
    /// We get the error: "Cannot use instance member 'title' within property initializer; property initializers run before 'self' is available"
    private lazy var resultStackView = UIStackView.create(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [
            headerLabel,
            amountPerPersonLabel,
            horizontalDivider,
            // Adding another spacer view so that we have more padding than just 8 between the divider and the totalTipAndBillView
            // This way we will have 16 between the divider and the last view instead of just 8 (8 between divider and spacer + 8 between spacer and view)
            spacerView(height: 0),
            totalTipAndBillView
        ]
    )
    
    private let totalBillView = AmountView(title: .Result.totalBill, alignment: .left, amountIdentifier: .totalBillValueLabel)
    private let totalTipView = AmountView(title: .Result.totalTip, alignment: .right, amountIdentifier: .totalTipValueLabel)
    
    private lazy var totalTipAndBillView = UIStackView.create(
        axis: .horizontal,
        spacing: 0,
        distribution: .fillEqually,
        arrangedSubviews: [
            totalBillView,
            UIView(), // spacer view, just like using Spacer() in HStack in SwiftUI
            totalTipView
        ]
    )
    
    // MARK: - Lifecycle -
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultView {
    func configure(result: Result) {
        amountPerPersonLabel.attributedText = Self.amountPerPersonAttributedString(for: result.amountPerPerson.currencyFormatted)
        totalBillView.configure(amount: result.totalBill)
        totalTipView.configure(amount: result.totalTip)
    }
}

private extension ResultView {
    func layout() {
        addSubview(resultStackView)
        backgroundColor = .white
        setupConstraints()
        addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .black,
            radius: 12.0,
            opacity: 0.1
        )
    }
    
    func setupConstraints() {
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        horizontalDivider.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
    
    func spacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { $0.height.equalTo(height) }
        // Same as:
        // view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
    static func amountPerPersonAttributedString(for string: String) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: string,
            attributes: .font(.bold(ofSize: 48))
        )
        text.addAttributes(
            .font(.bold(ofSize: 24)),
            range: NSMakeRange(0, 1)
        )
        return text
    }
}
