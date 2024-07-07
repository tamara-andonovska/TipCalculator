//
//  CalculatorViewModel.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/2/24.
//

import Foundation
import Combine

class CalculatorViewModel {
    // Define the input and the output.
    // Business logic, brain, interaction, processing
    
    // Similarly to VIPER with UIKit, we have the input and output
    struct Input {
        // Input for the VM, what should the VM get from the View/View Controller, eg. text field inputs, taps, etc.
        
        let bill: AnyPublisher<Double, Never> // Bill value from bill input field
        let tip: AnyPublisher<Tip, Never> //
        let numberOfPeople: AnyPublisher<Int, Never> // Number of people splitting the bill
        
        // These publishers will not error out.
        
        let logoTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        // Output from the VM, what the VM should send to the View/View Controller, eg. results of computation
        // In our case we need the calculations that we then should show in the ResultView.
        let updateView: AnyPublisher<Result, Never>
        let resetCalculator: AnyPublisher<Void, Never>
    }
    
    private let audioService: AudioServiceable
    
    init(audioService: AudioServiceable = AudioService()) {
        self.audioService = audioService
    }
    
    func transform(input: Input) -> Output { // ~ configure in VIPER's presenter
        let updatePublisher = Publishers
            .CombineLatest3(
                input.bill,
                input.tip,
                input.numberOfPeople
            )
            .map { [unowned self] bill, tip, numberOfPeople in
                let totalTip = tipAmount(tip, from: bill)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(numberOfPeople)
                
                return Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip)
            }
            .eraseToAnyPublisher()
        
        // Since this is the only thing we need to do, we don't really need to have the VM handling this.
        let resetCalculatorPublisher = input.logoTapped
            .handleEvents(receiveOutput: { [unowned self] in
                audioService.playSound()
            })
            .eraseToAnyPublisher()
        
        return Output(updateView: updatePublisher, resetCalculator: resetCalculatorPublisher)
    }
    
    private func tipAmount(_ tip: Tip, from bill: Double) -> Double {
        switch tip {
        case .none: 0
        case .tenPercent: bill * 0.1
        case .fifteenPercent: bill * 0.15
        case .twentyPercent: bill * 0.2
        case .custom(let value): Double(value)
        }
    }
}

struct Result {
    let amountPerPerson: Double
    let totalBill: Double
    let totalTip: Double
}
