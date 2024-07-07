//
//  MVVMPracticeProjectTests.swift
//  MVVMPracticeProjectTests
//
//  Created by Tamara Andonovska on 6/1/24.
//

import XCTest
import Combine
@testable import MVVMPracticeProject

// TODO: fix vo bill input DI view da se expandne kolku sto e mozno
final class MVVMPracticeProjectTests: XCTestCase {
    // sut = system under test, but I preferer using the actual name of whatever is being tested
    private var calculatorViewModel: CalculatorViewModel!
    // ! because no initializier is present, instead we initialize in the setUp method
    private var cancellables: Set<AnyCancellable>!
    private var audioServiceMock: AudioServiceMock!
    
    override func setUp() {
        // Before each test case
        super.setUp()
        
        audioServiceMock = .init()
        calculatorViewModel = .init(audioService: audioServiceMock)
        cancellables = .init()
    }
    
    override func tearDown() {
        // After each test case
        super.tearDown()
        calculatorViewModel = nil
        cancellables = nil
        audioServiceMock = nil
    }
    
    func testResultWithoutTipForOnePerson() {
        let bill = 100.0
        let tip = Tip.none
        let numberOfPeople = 1
        
        let input = CalculatorViewModel.Input(
            bill: Just(bill).eraseToAnyPublisher(),
            tip: Just(tip).eraseToAnyPublisher(),
            numberOfPeople: Just(numberOfPeople).eraseToAnyPublisher(),
            logoTapped: Just(()).eraseToAnyPublisher()
        )
        
        // We will be testing the output of the VM based on the input above.
        let output = calculatorViewModel.transform(input: input)
        output.updateView
            .sink(receiveValue: { result in
                XCTAssertEqual(result.totalBill, 100)
                XCTAssertEqual(result.totalTip, 0)
                XCTAssertEqual(result.amountPerPerson, 100)
            })
            .store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2People() {
        let bill = 100.0
        let tip = Tip.none
        let numberOfPeople = 2
        
        let input = CalculatorViewModel.Input(
            bill: Just(bill).eraseToAnyPublisher(),
            tip: Just(tip).eraseToAnyPublisher(),
            numberOfPeople: Just(numberOfPeople).eraseToAnyPublisher(),
            logoTapped: Just(()).eraseToAnyPublisher()
        )
        
        let output = calculatorViewModel.transform(input: input)
        output.updateView
            .sink(receiveValue: { result in
                XCTAssertEqual(result.totalBill, 100)
                XCTAssertEqual(result.totalTip, 0)
                XCTAssertEqual(result.amountPerPerson, 50)
            })
            .store(in: &cancellables)
    }
    
    func testResultWith10PercentTipFor2People() {
        let bill = 100.0
        let tip = Tip.tenPercent
        let numberOfPeople = 2
        
        let input = CalculatorViewModel.Input(
            bill: Just(bill).eraseToAnyPublisher(),
            tip: Just(tip).eraseToAnyPublisher(),
            numberOfPeople: Just(numberOfPeople).eraseToAnyPublisher(),
            logoTapped: Just(()).eraseToAnyPublisher()
        )
        
        let output = calculatorViewModel.transform(input: input)
        output.updateView
            .sink(receiveValue: { result in
                XCTAssertEqual(result.totalBill, 110)
                XCTAssertEqual(result.totalTip, 10)
                XCTAssertEqual(result.amountPerPerson, 55)
            })
            .store(in: &cancellables)
    }
    
    func testResultWithCustomTipFor4People() {
        let bill = 300.0
        let tip = Tip.custom(value: 100)
        let numberOfPeople = 4
        
        let input = CalculatorViewModel.Input(
            bill: Just(bill).eraseToAnyPublisher(),
            tip: Just(tip).eraseToAnyPublisher(),
            numberOfPeople: Just(numberOfPeople).eraseToAnyPublisher(),
            logoTapped: Just(()).eraseToAnyPublisher()
        )
        
        let output = calculatorViewModel.transform(input: input)
        output.updateView
            .sink(receiveValue: { result in
                XCTAssertEqual(result.totalBill, 400)
                XCTAssertEqual(result.totalTip, 100)
                XCTAssertEqual(result.amountPerPerson, 100)
            })
            .store(in: &cancellables)
    }
    
    func testCalculatorResetAndSoundPlayedOnLogoTap() {
        let bill = 300.0
        let tip = Tip.custom(value: 100)
        let numberOfPeople = 4
        let expectation1 = XCTestExpectation(description: "Reset calculator called")
        let expectation2 = audioServiceMock.expectation
        
        let logoTap = PassthroughSubject<Void, Never>()
        let input = CalculatorViewModel.Input(
            bill: Just(bill).eraseToAnyPublisher(),
            tip: Just(tip).eraseToAnyPublisher(),
            numberOfPeople: Just(numberOfPeople).eraseToAnyPublisher(),
            logoTapped: logoTap.eraseToAnyPublisher()
        )
        
        let output = calculatorViewModel.transform(input: input)
        output.resetCalculator
            .sink(receiveValue: { _ in
                expectation1.fulfill()
            })
            .store(in: &cancellables)
        
        logoTap.send(())
        wait(for: [expectation1, expectation2], timeout: 1.0)
        
    }
}

class AudioServiceMock: AudioServiceable {
    var expectation = XCTestExpectation(description: "Play sound called")
    func playSound() {
        expectation.fulfill()
    }
}
