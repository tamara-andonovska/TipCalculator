//
//  TipInputView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import Foundation
import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    // MARK: - Private properties -
    private var cancellables = Set<AnyCancellable>()
    
    // Initial value of the tip is none (no tip). Helps us with the states of tip buttons selection, as well as the tip calculations.
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    var tipPublisher: AnyPublisher<Tip, Never> {
        tipSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Views -
    
    private let headerView = HeaderView(mainText: .TipInput.choose, descriptionText: .TipInput.yourTip)

    private lazy var tenPercentButton: UIButton = {
        let button = createButton(forTip: .tenPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.tenPercentButton.rawValue
        return button
    }()
    
    private lazy var fifteenPercentButton: UIButton = {
        let button = createButton(forTip: .fifteenPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.fifteenPercentButton.rawValue
        return button
    }()
    
    private lazy var twentyPercentButton: UIButton = {
        let button = createButton(forTip: .twentyPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.twentyPercentButton.rawValue
        return button
    }()
    
    private lazy var customPercentButton: UIButton = {
        let button = UIButton()
        button.setTitle(.TipInput.customTip, for: .normal)
        button.titleLabel?.font = .bold(ofSize: 20)
        button.backgroundColor = .secondaryBackground
        button.setTitleColor(.primaryText, for: .normal) // Had to add this, since just using tint color was not working.
        // Tint color is not going to do anything here since we only have text for the button.
        // button.tintColor = .primaryText
        button.cornerRadius(8.0)
        
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.customTipButton.rawValue
        
        return button
    }()
    
    private lazy var percentButtonsStack = UIStackView.create(
        axis: .horizontal,
        spacing: 16,
        // fillEqualy - all of the subviews will take the same space, since it's a horizontal stack = same width, the stack's space will be equally given to each subview
        distribution: .fillEqually,
        arrangedSubviews: [
            tenPercentButton,
            fifteenPercentButton,
            twentyPercentButton
        ]
    )
    
    /// Stack view distribution:
    /// 1. fill = default, the stack view resizes the view so they take all the available space along the axis of the stack (vertically for vertical, horizontally for horizontal)
    /// It keep all but 1 in their natural size, based on the content hugging priority (will stretch the one with the smallest CHP)
    /// 2. fillEqually = each view takes the same size, CHP doesn't matter.
    /// 3. fillProportionally = each view takes as much they need proportionally filling the whole availabe space along the stack's axis
    /// Needs the views to have intrinsic content size. Depending on it, each view will get a certain amount of space (eg. longer text will get more space than shorter one).
    /// 4. equalSpacing = the spacing between the views in the stack will be the same and they will take the whole available space along the stack's axis
    /// 5. equalCentering = the spacing between each view's CENTER will be the same and they will take the whole available space along the stack's axis
    /// https://spin.atomicobject.com/uistackview-distribution/

    private lazy var buttonsStack = UIStackView.create(
        axis: .vertical,
        spacing: 16,
        distribution: .fillEqually,
        arrangedSubviews: [
            percentButtonsStack,
            customPercentButton
        ]
    )
    
    // MARK: - Lifecycle -
    
    init() {
        super.init(frame: .zero)
        layout()
        handleTipChoice()
        observeTipSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        tipSubject.send(.none)
    }
}

private extension TipInputView {
    func layout() {
        [headerView, buttonsStack].forEach(addSubview(_:)) // or forEach(addSubview)
        setupConstraints()
    }
    
    func setupConstraints() {
        buttonsStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonsStack.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(percentButtonsStack.snp.centerY)
        }
    }
    
    func handleTipChoice() {
        tenPercentButton
            .tapPublisher
            .sink(receiveValue: { [unowned self] in
                tipSubject.send(.tenPercent)
                // Same as:
                // tipSubject.value = .tenPercent
            })
            .store(in: &cancellables)
        
        /*
        // This can be also done this way:
        tenPercentButton
            .tapPublisher
            .flatMap { Just(Tip.tenPercent) } // Transform tap event to another publisher, here from AnyPublisher<Void, Never> to AnyPublisher<Tip, Never>
            // WARNING: assign strongly captures self!
            .assign(to: \.value, on: tipSubject)
            // The current value subject has (get/set) value property.
            // This is the same as writing tipSubject.value = .tenPercent in a sink, i.e. we assign the value from the chain/publisher
            // to the value of the tip subject.
            .store(in: &cancellables)
        */
        
        fifteenPercentButton
            .tapPublisher
            .sink(receiveValue: { [unowned self] in
                tipSubject.send(.fifteenPercent)
            })
            .store(in: &cancellables)
        
        twentyPercentButton
            .tapPublisher
            .sink(receiveValue: { [unowned self] in
                tipSubject.send(.twentyPercent)
            })
            .store(in: &cancellables)
        
        customPercentButton
            .tapPublisher
            .sink(receiveValue: { [unowned self] in
                handleCustomTip()
            })
            .store(in: &cancellables)
    }
    
    func handleCustomTip() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: .TipInput.enterCustomTip,
                message: nil,
                preferredStyle: .alert
            )
            
            controller.addTextField { textField in
                textField.placeholder = .TipInput.makeItGenerous
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
                textField.accessibilityIdentifier = ScreenIdentifier.TipInputView.customTipAlertTextField.rawValue
            }
            
            let cancelAction = UIAlertAction(title: .Action.cancel, style: .cancel)
            let okAction = UIAlertAction(title: .Action.ok, style: .default) { [unowned self] _ in
                guard let text = controller.textFields?.first?.text,
                    let value = Int(text)
                else { return }
                tipSubject.send(.custom(value: value))
            }
            
            controller.addAction(cancelAction)
            controller.addAction(okAction)
            
            return controller
        }()
        
        
        parentViewController?.present(alertController, animated: true)
    }
    
    func observeTipSelection() {
        tipSubject
            .sink(receiveValue: {
                [unowned self] tip in
                resetSelection()
                switch tip {
                case .none: break
                case .tenPercent: tenPercentButton.backgroundColor = .accent
                case.fifteenPercent: fifteenPercentButton.backgroundColor = .accent
                case .twentyPercent: twentyPercentButton.backgroundColor = .accent
                case .custom(let value):
                    customPercentButton.backgroundColor = .accent
                    let text = Self.customTipButtonAttributedString(for: "$\(value)")
                    text.addAttributes(
                        .font(.bold(ofSize: 14)),
                        range: NSRange(location: 0, length: 1)
                    )
                    customPercentButton.setAttributedTitle(text, for: .normal)
                }
            })
            .store(in: &cancellables)
    }
    
    func resetSelection() {
        [
            tenPercentButton,
            fifteenPercentButton,
            twentyPercentButton,
            customPercentButton
        ]
            .forEach {
                $0.backgroundColor = .secondaryBackground
            }
        let text = Self.customTipButtonAttributedString(for: .TipInput.customTip)
        customPercentButton.setAttributedTitle(text, for: .normal)
    }
}

// MARK: - View factory -

private extension TipInputView {
    func createButton(forTip tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .secondaryBackground
        button.cornerRadius(8.0)
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.font] = UIFont.bold(ofSize: 20)
        attributes[.foregroundColor] = UIColor.primaryText
        let text = NSMutableAttributedString(string: tip.description, attributes: attributes)
        text.addAttributes(.font(.demiBold(ofSize: 14)), range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        /// Other button states: application, disabled, focused, highlighted, reserved, selected
        /// We don't need to handle them here since our button is always in normal, enabled state.
        
        return button
    }
    
    static func customTipButtonAttributedString(for string: String) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(
            string: string,
            attributes: .font(.bold(ofSize: 20))
        )
        return text
    }
}
