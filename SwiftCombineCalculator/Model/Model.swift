//
//  Model.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import UIKit

final class Model {
    
    struct Result {
        
        let amountPerPerson: Double
        let totalBill: Double
        let totalTip: Double
    }
}

class MyButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            backgroundColor = isHighlighted ? .systemBlue : .lightGray
        }
    }
}
