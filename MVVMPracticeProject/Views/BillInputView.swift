//
//  BillInputView.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import UIKit
import Combine
import CombineCocoa

class BillInputView: UIView {
    
    // MARK: - Private properties -
    
    private var cancellables = Set<AnyCancellable>()
    /// Subject is RW, Publisher is R
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    
    // MARK: - Public properties -
    
    var billPublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Views -
    
    private let headerView: HeaderView = {
        return HeaderView(mainText: .BillInput.enter, descriptionText: .BillInput.yourBill)
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius(8.0)
        return view
    }()
    
    private let currencyDenominationLabel: UILabel = {
        let label = UILabel.create(
            text: "$",
            font: .demiBold(ofSize: 18)
        )
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        // This label and the text field are in the same line.
        // We want to make sure that the label is tightly wrapper, so it's "hugging" itself as tightly (high/ default high) as possible
        // so the text field expands as much as it wants, and it does it horizontally.
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.demiBold(ofSize: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // Same reason as above, except we want this to expand as much as possible horizontally, i.e. not "hug" itself.
        
        textField.tintColor = .primaryText
        /// Tint color = key color that indicates interactivity and selection state, main color of the component
        /// Text color = object of text
        textField.textColor = .primaryText
        
        textField.accessibilityIdentifier = ScreenIdentifier.BillInputView.textField.rawValue
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36)) // Possible only because of lazy.
        // To put configuration
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: .Action.done,
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            doneButton
        ]
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        
        return textField
    }()
    
    // MARK: - Lifecycle -
    
    init() {
        super.init(frame: .zero)
        layout()
        observeBillInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BillInputView {
    func reset() {
        textField.text = .none
    }
}

private extension BillInputView {
    func layout() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        // Same as:
        // addSubview(headerView)
        // addSubview(textFieldContainerView)
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(textFieldContainerView.snp.centerY)
            $0.width.equalTo(68)
            $0.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        currencyDenominationLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            $0.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc
    func doneButtonTapped() {
        textField.endEditing(true)
    }
    
    func observeBillInput() {
        textField
            .textPublisher // AnyPublisher<String?, Never>, out of the box publisher from CombineCocoa
            // First event is empty string on tapping on the text field without even getting to type anything in.
            .dropFirst()
            // We want to wait for about 0.3 seconds after user stops typing to execute the calculations
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            // We want to not trigger events if the user keeps adding and deleting the same last character.
            .removeDuplicates()
            .sink(receiveValue: { [unowned self] bill in
                guard let bill else { return }
                billSubject.send(bill.doubleValue ?? 0)
            })
            .store(in: &cancellables)
    }
}
