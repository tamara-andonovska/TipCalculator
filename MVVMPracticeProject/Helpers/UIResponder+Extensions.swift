//
//  UIResponder+Extensions.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/2/24.
//

import Foundation
import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        next as? UIViewController ?? next?.parentViewController
    }
    
    /// `next` is the next responder in chain, which we try to cast as a `UIViewController`
    /// If the casting fails, meaning that `next` is not of type `UIViewController`,
    /// we get the parent view controller of next.
}
