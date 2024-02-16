//
//  Utility.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import UIKit

// MARK: - Utility (單例)
final class Utility: NSObject {
    
    static let shared = Utility()
    private override init() {}
}

// MARK: - 小工具 (function)
extension Utility {
    
    func labelMaker(text: String?, font: UIFont, backgroundColor: UIColor = .clear, textColor: UIColor? = Constant.ThemeColor.text.color(), textAlignment: NSTextAlignment = .center) -> UILabel {
        
        let label = UILabel()
        
        label.text = text
        label.font = font
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = textAlignment
        
        return label
    }
}
