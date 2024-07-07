//
//  UIView+Extensions.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/1/24.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        // Adding rounded corners:
        layer.cornerRadius = radius
        
        // Standard part of adding a shadow
        /// If we set masksToBounds to false on the current layer and add a shadow,
        /// then we get the desired effect of having both a shadow and a corner radius.
        ///
        layer.masksToBounds = false
        
        // Adding shadow:
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        
        layer.backgroundColor = backgroundColor?.cgColor
    }
    
    func cornerRadius(_ radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func add(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}

/// Adding both rounded corners & drop shadow on a view:
/// First, you apply corner radius, which gets applied to the layer (`CALayer`) i.e. `layer.cornerRadius = radius`.
/// This means the corner radius is only applied to the:
/// 1. background color
/// 2. border
/// If the layer has any `contents`, then `masksToBounds` needs to be set to true to clip the content as well.
/// Second, you apply a shadow to the `CALayer`.
/// https://medium.com/swifty-tim/views-with-rounded-corners-and-shadows-c3adc0085182
