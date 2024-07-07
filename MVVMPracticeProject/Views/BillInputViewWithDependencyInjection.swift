//
//  BillInputViewWithDependencyInjection.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/5/24.
//

import UIKit
import Combine
import CombineCocoa

class BillInputViewWithDependencyInjection: UIView {
    
    // MARK: - Private properties -
    
    private var cancellables = Set<AnyCancellable>()
    /// Subject is RW, Publisher is R
    private let billSubject: PassthroughSubject<Double, Never>
    
    // MARK: - Views -
    
    private let headerView: HeaderView = {
        HeaderView(mainText: .BillInput.enter, descriptionText: .BillInput.yourBill)
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
            font: .bold(ofSize: 24)
        )
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        // This label and the text field are in the same line.
        // We want to make sure that the label is tightly wrapped, so it's "hugging" itself as tightly (high/default high) as possible,
        // taking up as little space as possible (therefore being at the beginning of the container)
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
    
    lazy var stackView = UIStackView.create(
        axis: .horizontal,
        spacing: 24,
        distribution: .fill,
        arrangedSubviews: [
            headerView,
            textFieldContainerView
        ]
    )
    
    // MARK: - Lifecycle -
    
    // We inject the billSubject, which is far better than playing around with a public var property!
    init(billSubject: PassthroughSubject<Double, Never>) {
        self.billSubject = billSubject
        super.init(frame: .zero)
        layout()
        observeBillInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BillInputViewWithDependencyInjection {
    func reset() {
        textField.text = .none
        billSubject.send(0)
    }
}

private extension BillInputViewWithDependencyInjection {
    func layout() {
        addSubview(stackView)
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
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
