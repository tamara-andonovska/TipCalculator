//
//  LogoView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import Foundation
import UIKit

class LogoView: UIView {
    
    // MARK: - Views -
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: .logoImage)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: .Logo.mrsTip,
            attributes: .font(.demiBold(ofSize: 16))
        )
        text.addAttributes(
            .font(.demiBold(ofSize: 24)),
            range: NSMakeRange(4, 3) // Start from index 4, and apply the attribute to the next 3 chars starting from 4, so 4, 5, 6
        )
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel = UILabel.create(text: .Logo.calculator, font: .demiBold(ofSize: 20), alignment: .left)
    
    private lazy var verticalStackView = UIStackView.create(
        axis: .vertical,
        spacing: -4,
        arrangedSubviews: [topLabel, bottomLabel]
    )
    
    private lazy var stackView = UIStackView.create(
        axis: .horizontal,
        spacing: 8,
        alignment: .center,
        arrangedSubviews: [imageView, verticalStackView]
    )
    
    // MARK: - Lifecycle -
    
    init() {
        super.init(frame: .zero)
        layout()
        accessibilityIdentifier = ScreenIdentifier.LogoView.logoViewIcon.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LogoView {
    func layout() {
        addSubview(stackView)
        setupConstraints()
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
}
