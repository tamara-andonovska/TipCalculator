//
//  SplitInputView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import Foundation
import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    // MARK: - Private properties -
    
    private var cancellables = Set<AnyCancellable>()
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    
    // MARK: - Public properties -
    
    var splitPublisher: AnyPublisher<Int, Never> {
        splitSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Views -
    
    private let headerView = HeaderView(mainText: .SplitInput.split, descriptionText: .SplitInput.theTotal)
    
    private lazy var decrementButton: UIButton = {
        let button = createButton(text: "-", corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        // min x min y i.e. (0, 0) i.e. left bottom
        // min x max y i.e. (0, 1) i.e. left top
        button.accessibilityIdentifier = ScreenIdentifier.SplitInputView.decrementButton.rawValue
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = createButton(text: "+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        /// The handling can be done directly here like this:
        /// let button = ...
        /// button.tapPublisher...
        /// return button
        ///
        /// or simply by creating a handler method that we will call in the init that will handle the values from the
        button.accessibilityIdentifier = ScreenIdentifier.SplitInputView.incrementButton.rawValue
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel.create(text: "1", font: UIFont.bold(ofSize: 20), backgroundColor: .white)
        label.accessibilityIdentifier = ScreenIdentifier.SplitInputView.quantityValueLabel.rawValue
        return label
    }()
    
    private lazy var stackView = UIStackView.create(
        axis: .horizontal,
        spacing: 0,
        arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
        ]
    )
    
    // MARK: - Lifecycle -
    
    init() {
        super.init(frame: .zero)
        layout()
        handleNumberOfPeople()
        observeNumberOfPeople()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SplitInputView {
    func reset() {
        splitSubject.send(1)
    }
}

private extension SplitInputView {
    func layout() {
        [headerView, stackView].forEach(addSubview)
        setupConstraints()
    }
    
    func setupConstraints() {
        // To position a view, we need to position it vertically or horizontally.
        // Horizontally:
        // This means using either (leading + traling) or centerX or (leading/trailing + width)
        // Vertically:
        // This means using either (top + bottom) or centerY or (top/bottom + height)
        headerView.snp.makeConstraints { make in
            // Horizontally:
            make.leading.equalToSuperview()
            make.trailing.equalTo(stackView.snp.leading).offset(-24) // With this we also set the stackView.
            make.width.equalTo(68) // This is not actually required for the view to be correctly positioned and its position uniquily identified.
            // The width is set so that the header takes just enough space, so that the stack view can take the rest.
            // The correct way to do this would be:
            // 1. Either putting the views in a stack with distribution fillProportionally
            // 2. Using hugging priority where the header would have bigger hugging priority set.
            
            // Vertically:
            make.centerY.equalTo(stackView.snp.centerY)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height) // to make the buttons square
            }
        }
        
        quantityLabel.snp.makeConstraints { 
            $0.height.equalTo(incrementButton.snp.height)
        }
    }
    
    func handleNumberOfPeople() {
        incrementButton
            .tapPublisher
            .flatMap { [unowned self] _ in
                Just(splitSubject.value + 1)
            }
            .sink(receiveValue: { [unowned self] in
                splitSubject.value = $0
            }) // or assign(to:on:)
            .store(in: &cancellables)
        
        decrementButton
            .tapPublisher
            .flatMap { [unowned self] _ in
                Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
            }
            .sink(receiveValue: { [unowned self] in
                splitSubject.value = $0
            }) // or assign(to:on:)
            .store(in: &cancellables)
    }
    
    func observeNumberOfPeople() {
        splitSubject
            .sink(receiveValue: { [unowned self] quantity in
                quantityLabel.text = quantity.stringValue
            })
            .store(in: &cancellables)
    }
}

// MARK: - View factory -

private extension SplitInputView {
    func createButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .bold(ofSize: 20)
        button.backgroundColor = .primaryText
        button.add(corners: corners, radius: 8.0)
        return button
    }
}
