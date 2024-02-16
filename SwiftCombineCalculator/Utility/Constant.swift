//
//  Constant.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import UIKit

// MARK: 自訂常數
final class Constant: NSObject {}

// MARK: typealias
extension Constant {
    typealias TipButton = (type: Constant.TipButtonTagType?, value: Double)  // 小費設定值 (類型, 數值)
}

// MARK: enum
extension Constant {
    
    /// 小費按鈕分類
    enum TipButtonTagType: Int {
        
        case tenPercent = 110       // 10%
        case fiftenPercent = 115    // 15%
        case twentyPercent = 120    // 20%
        case custom = 200           // 自訂
    }
    
    /// 平分人數按鈕分類
    enum SplitButtonTagType: Int {
        
        case minus = 101            // 減少
        case plus = 201             // 增加

        /// 圓角方向設定
        /// - Returns: CACornerMask
        func corners() -> CACornerMask {
            switch self {
            case .minus: return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .plus: return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    /// 主題字型
    enum ThemeFont {
        
        case regular
        case bold
        case demibold
        
        /// [字型](https://developer.apple.com/fonts/system-fonts/)
        /// - Parameter size: CGFloat
        func font(ofSize size: CGFloat) -> UIFont {
            
            let fontName: String
            
            switch self {
            case .regular: fontName = "AvenirNext-Regular"
            case .bold: fontName = "AvenirNext-Bold"
            case .demibold: fontName = "AvenirNext-DemiBold"
            }
            
            return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
        }
    }
}
