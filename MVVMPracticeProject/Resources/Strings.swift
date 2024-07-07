//
//  String+Extensions.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/4/24.
//

import Foundation

extension String {
    enum Logo {
        static var mrsTip = "Mrs TIP"
        static var calculator = "Calculator"
    }
    
    enum Result {
        static var totalPerPerson = "Total p/person"
        static var totalBill = "Total bill"
        static var totalTip = "Total tip"
    }
    
    enum BillInput {
        static var enter = "Enter"
        static var yourBill = "your bill"
    }
    
    enum TipInput {
        static var choose = "Choose"
        static var yourTip = "your tip"
        static var customTip = "Custom tip"
        static var enterCustomTip = "Enter custom tip"
        static var makeItGenerous = "Make it generous"
    }
    
    enum SplitInput {
        static var split = "Split"
        static var theTotal = "the total"
    }
    
    enum Action {
        static var done = "Done"
        static var ok = "OK"
        static var cancel = "Cancel"
    }
}
