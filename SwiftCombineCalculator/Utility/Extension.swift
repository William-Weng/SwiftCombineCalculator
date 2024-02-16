//
//  Extension.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import UIKit
import WWPrint

// MARK: - UIResponder (function)
extension UIResponder {
    
    /// 尋找上一層的UIViewController
    /// - Returns: T?
    func _parentViewController<T: UIViewController>() -> T? {
        guard let responder = next else { return nil }
        return responder as? T ?? responder._parentViewController()
    }
}

// MARK: - Double (function)
extension Double {
    
    /// [幣值格式化 (小數 / 整數)](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-numberformatter-顯示-money-2ef9e1abfc10)
    /// - Returns: String
    /// - Parameters:
    ///   - minimumFractionDigits: [Int](https://stackoverflow.com/questions/41558832/how-to-format-a-double-into-currency-swift-3)
    ///   - groupingSize: Int
    func _currencyFormatted(minimumFractionDigits: Int = 2, groupingSize: Int = 3) -> String {
        
        let formatter = NumberFormatter()
        var isWholeNumber: Bool { isZero ? true : (!isNormal ? false : self == rounded())}
        
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = (isWholeNumber) ? 0 : minimumFractionDigits
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "-"
        formatter.groupingSize = groupingSize
        
        return formatter.string(for: self) ?? ""
    }
}

// MARK: - String (subscript function)
extension String {
    
    /// [在Swift編程語言中獲取字符串的第n個字符](https://www.codenong.com/24092884/)
    /// "subscript"[5] => "r"
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// MARK: - String (function)
extension String {
    
    /// 文字轉Int
    /// - Returns: Int?
    func _Int() -> Int? { return Int(self) }
    
    /// 文字轉Double
    /// - Returns: Double?
    func _Double() -> Double? { return Double(self) }
}

// MARK: - UIView (function)
extension UIView {
    
    /// [設置陰影](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/同時實現圓角和陰影-bee263a41c7)
    /// - Parameters:
    ///   - color: [陰影顏色](https://medium.com/swifty-tim/views-with-rounded-corners-and-shadows-c3adc0085182?source=post_page-----bee263a41c7--------------------------------)
    ///   - backgroundColor: 陰影背景色
    ///   - offset: 陰影位移
    ///   - opacity: 陰影不透明度
    ///   - radius: 陰影半徑
    ///   - cornerRadius: 圓角半徑
    func _shadow(color: UIColor, backgroundColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat) {
        layer._shadow(color: color, backgroundColor: backgroundColor, offset: offset, opacity: opacity, radius: radius, cornerRadius: cornerRadius)
    }
}

// MARK: - CALayer (function)
extension CALayer {
    
    /// [設置陰影](https://www.jianshu.com/p/2c90d6a637f7)
    /// - Parameters:
    ///   - color: 陰影顏色
    ///   - backgroundColor: 陰影背景色
    ///   - offset: 陰影位移
    ///   - opacity: 陰影不透明度
    ///   - radius: 陰影半徑
    ///   - cornerRadius: 圓角半徑
    func _shadow(color: UIColor, backgroundColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat) {
        
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor.cgColor
    }
    
    /// [設定圓角](https://www.appcoda.com.tw/calayer-introduction/)
    /// - 可以個別設定要哪幾個角 / 預設是四個角全是圓角
    /// - Parameters:
    ///   - radius: 圓的半徑
    ///   - masksToBounds: Bool
    ///   - corners: 圓角要哪幾個邊
    func _maskedCorners(radius: CGFloat, masksToBounds: Bool = true, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        self.masksToBounds = masksToBounds
        self.maskedCorners = corners
        self.cornerRadius = radius
    }
}
