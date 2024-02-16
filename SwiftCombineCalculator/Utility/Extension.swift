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
    
    func _currencyFormatted() -> String {
        
        let formatter = NumberFormatter()
        var isWholeNumber: Bool { isZero ? true : (!isNormal ? false : self == rounded())}
        
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = (isWholeNumber) ? 0 : 2
        
        wwPrint("\(self) / \(self == rounded())")
        
        return formatter.string(for: self) ?? ""
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

// MARK: - UIColr (init function)
extension UIColor {
    
    /// UIColor(red: 255, green: 255, blue: 255, alpha: 255)
    /// - Parameters:
    ///   - red: 紅色 => 0~255
    ///   - green: 綠色 => 0~255
    ///   - blue: 藍色 => 0~255
    ///   - alpha: 透明度 => 0~255
    convenience init(red: Int, green: Int, blue: Int, alpha: Int) { self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0) }
    
    /// UIColor(red: 255, green: 255, blue: 255)
    /// - Parameters:
    ///   - red: 紅色 => 0~255
    ///   - green: 綠色 => 0~255
    ///   - blue: 藍色 => 0~255
    convenience init(red: Int, green: Int, blue: Int) { self.init(red: red, green: green, blue: blue, alpha: 255) }
    
    /// UIColor(rgb: 0xFFFFFF)
    /// - Parameter rgb: 顏色色碼的16進位值數字
    convenience init(rgb: Int) { self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF) }
    
    /// UIColor(rgba: 0xFFFFFFFF)
    /// - Parameter rgba: 顏色的16進位值數字
    convenience init(rgba: Int) { self.init(red: (rgba >> 24) & 0xFF, green: (rgba >> 16) & 0xFF, blue: (rgba >> 8) & 0xFF, alpha: (rgba) & 0xFF) }
    
    /// UIColor(rgb: #FFFFFF)
    /// - Parameter rgb: 顏色的16進位值字串
    convenience init(rgb: String) {
        
        let ruleRGB = "^#[0-9A-Fa-f]{6}$"
        let predicateRGB = Constant.Predicate.matches(regex: ruleRGB).build()
        
        guard predicateRGB.evaluate(with: rgb),
              let string = rgb.split(separator: "#").last,
              let number = Int.init(string, radix: 16)
        else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0); return
        }
        
        self.init(rgb: number)
    }
    
    /// UIColor(rgba: #FFFFFFFF)
    /// - Parameter rgba: 顏色的16進位值字串
    convenience init(rgba: String) {
        
        let ruleRGBA = "^#[0-9A-Fa-f]{8}$"
        let predicateRGBA = Constant.Predicate.matches(regex: ruleRGBA).build()
        
        guard predicateRGBA.evaluate(with: rgba),
              let string = rgba.split(separator: "#").last,
              let number = Int.init(string, radix: 16)
        else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0); return
        }
        
        self.init(rgba: number)
    }
    
    /// UIColor(bitmap: [255, 128, 64, 128])
    /// - Parameter bitmap: RGBA的Array => [255, 128, 64, 128]
    convenience init(bitmap: [UInt8]) {
        switch bitmap.count {
        case 3:  self.init(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1.0)
        case 4:  self.init(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
        default: self.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
}

extension UIView {
    
    /// [設置陰影](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/同時實現圓角和陰影-bee263a41c7)
    /// - Parameters:
    ///   - color: [陰影顏色](https://medium.com/swifty-tim/views-with-rounded-corners-and-shadows-c3adc0085182?source=post_page-----bee263a41c7--------------------------------)
    ///   - backgroundColor: 陰影背景色
    ///   - offset: 陰影位移
    ///   - opacity: 陰影不透明度
    ///   - radius: 陰影半徑
    ///   - cornerRadius: 圓角半徑
    func _shadow(with color: UIColor, backgroundColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat) {
        layer._shadow(with: color, backgroundColor: backgroundColor, offset: offset, opacity: opacity, radius: radius, cornerRadius: cornerRadius)
    }
}

extension CALayer {
    
    /// [設置陰影](https://www.jianshu.com/p/2c90d6a637f7)
    /// - Parameters:
    ///   - color: 陰影顏色
    ///   - backgroundColor: 陰影背景色
    ///   - offset: 陰影位移
    ///   - opacity: 陰影不透明度
    ///   - radius: 陰影半徑
    ///   - cornerRadius: 圓角半徑
    func _shadow(with color: UIColor, backgroundColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat) {
        
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
