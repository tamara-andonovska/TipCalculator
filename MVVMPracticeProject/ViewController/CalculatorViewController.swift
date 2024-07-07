//
//  ViewController.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorViewController: UIViewController {
    
    /// We need to have a reference from the UIViewController to the view model (a regular class that we will use for the business logic i.e. calculations).
    private let calculatorViewModel = CalculatorViewModel()
    
    /// Cancellables have to be a var because new subscriptions get added to it and removed from it.
    /// Every subscription can be cancelled (hence the naming) if it's no longer needed which helps in avoiding potential memory leaks.
    /// https://ondrej-kvasnovsky.medium.com/why-do-we-need-cancellables-when-using-swift-combine-bb5cd1e91fe2
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture
            .tapPublisher
            .map { _ in } // or flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }()
    
    private lazy var logoTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        // We can also specify how many taps are needed for the gesture.
        // tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture
            .tapPublisher
            .map { _ in }
            .eraseToAnyPublisher()
    }()
    
    // If instead of having public properties, we use DI to pass the subject that will be used then in the view, we first need to initialize it here.
    private let billSubject = PassthroughSubject<Double, Never>()
    
    // MARK: - Views -
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    // private let billInputView = BillInputView()
    private lazy var billInputView = BillInputViewWithDependencyInjection(billSubject: billSubject)
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var stackView = UIStackView.create(
        axis: .vertical,
        spacing: 36,
        arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView() // To push everything up and take as much space needed so the rest of the components are not expanded too much
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        /// We will call a bind method to bind the view model to view.
        bindViewModel()
        
        handleTapOutside()
        // handleResetCalculator()
    }
    
    /// We want to dismiss the keyboard if the user taps outside of the keyboard.
    private func handleTapOutside() {
        viewTapPublisher
            .sink(receiveValue: { [unowned self] in
                /// set endEditing to true to dismiss keyboard
                view.endEditing(true)
            })
            .store(in: &cancellables)
    }
    
    /// We want to reset the calculator if user taps on the logo.
    /*
    private func handleResetCalculator() {
        // IT'S NOT NEEDED IF WE SEND IT TO THE VIEW MODEL AND THEN HANDLE IT THROUGH THE OUTPUT, line 143
        // We can either do this or the other, not both!
        logoTapPublisher
            .sink(receiveValue: { [unowned self] in
                billInputView.reset()
                tipInputView.reset()
                splitInputView.reset()
            })
            .store(in: &cancellables)
    }
     */

    private func layout() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(stackView)
        view.backgroundColor = .primaryBackground
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(24)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-24)
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
        }
        
        logoView.snp.makeConstraints { $0.height.equalTo(48) }
        resultView.snp.makeConstraints { $0.height.equalTo(224) }
        billInputView.snp.makeConstraints { $0.height.equalTo(56) }
        tipInputView.snp.makeConstraints { $0.height.equalTo(56+56+16) }
        splitInputView.snp.makeConstraints { $0.height.equalTo(56) }
    }
    
    private func bindViewModel() {
        /// We use the configure method to bind.
        /// We pass the info we have from the view as input to the view model and the get the output from the transform/configure method.
        let input = CalculatorViewModel.Input(
            // billSubject if we are using DI, or the commented out without DI but with public property in the view
            bill: billSubject.eraseToAnyPublisher(),  // billInputView.billPublisher,
            tip: tipInputView.tipPublisher,
            numberOfPeople: splitInputView.splitPublisher,
            logoTapped: logoTapPublisher
        )
        
        let output = calculatorViewModel.transform(input: input)
        output
            .updateView
            .sink(receiveValue: { [unowned self] result in
                resultView.configure(result: result)
            })
            .store(in: &cancellables)
        
        output
            .resetCalculator
            .sink(receiveValue: { [unowned self] in
                billInputView.reset()
                tipInputView.reset()
                splitInputView.reset()
                
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    usingSpringWithDamping: 5.0,
                    initialSpringVelocity: 0.5,
                    options: .curveEaseInOut,
                    animations: { [unowned self] in
                        logoView.transform = .init(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1) { [unowned self] in
                            logoView.transform = .identity
                        }
                    }
                )
            })
            .store(in: &cancellables)
    }
}

