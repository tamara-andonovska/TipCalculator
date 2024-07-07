//
//  HeaderView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/2/24.
//

import Foundation
import UIKit

class HeaderView: UIView {
    /// If a UIView doesn't have an implementation with actual views, it will collapse where in the view it's used
    /// i.e. not be visible, since it won't take any space unless it's height gets specified.
    /// Same applies for all views.
    
    // MARK: - Private properties -
    
    private let mainText: String
    private let descriptionText: String
    
    // MARK: - Views -
    
    private lazy var topLabel = UILabel.create(text: mainText, font: .bold(ofSize: 18))
    private lazy var bottomLabel = UILabel.create(text: descriptionText, font: .regular(ofSize: 18))
    
    /// Instead of using lazy vars for topLabel and bottomLabel, the mainText and descriptionText can be passed through a configure method which will get called where HeaderView gets initialized.
    /// A lazy var is used if we need to reference self before it's initialized.
    
    private lazy var stackView = UIStackView.create(
        axis: .vertical,
        spacing: -4,
        alignment: .leading,
        arrangedSubviews: [topLabel, bottomLabel]
    )
    
    init(mainText: String, descriptionText: String) {
        self.mainText = mainText
        self.descriptionText = descriptionText
        super.init(frame: .zero)
        // Given only as example:
        // setupView()
        // setupConstraints()
        /// They are not used at the moment in favor of the other implementation explained before the extension containing them, below.
        layout()
    }
    
    /// Most used cased when required init is called is when the view is created in IB which is not the case here
    /// so we can "safely" leave the fatal error here.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// I want this HeaderView to take as little space as possible horizontally, where used:
    /// Based on documentation:
    /// The size fitting most closely to targetSize in which the receiver's subtree can be laid out while optimally satisfying the constraints.
    /// If you want the smallest possible size, pass UILayoutFittingCompressedSize.
    override var intrinsicContentSize: CGSize {
        return stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

private extension HeaderView {
    func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

/// These can also be used by calling them in the init instead of calling layout() and using properties and lazy vars.
/// Right now, they aren't used.
extension HeaderView {
    func setupView() {
        let mainLabel = UILabel.create(text: mainText, font: .bold(ofSize: 18), alignment: .left)
        let descriptionLabel = UILabel.create(text: descriptionText, font: .regular(ofSize: 18), alignment: .left)
        
        let stackView = UIStackView.create(
            axis: .vertical,
            spacing: 4,
            arrangedSubviews: [mainLabel, descriptionLabel]
        )
        
        addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
