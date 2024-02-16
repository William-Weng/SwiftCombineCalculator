//
//  Constant.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import UIKit

final class Constant: NSObject {
    
    enum Tip {
        
        var stringVaule: String { value() }
        
        case none
        case tenPercent
        case fiftenPercent
        case twentyPercent
        case custom(value: Int)
        
        func value() -> String {
            
            let value: String
            
            switch self {
            case .none: value = ""
            case .tenPercent: value = "10%"
            case .fiftenPercent: value = "15%"
            case .twentyPercent: value = "20%"
            case .custom(let _value): value = "\(_value)%"
            }
            
            return value
        }
    }
}

extension Constant {
    typealias RGBAInformation = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)                                       // [RGBA色彩模式的數值](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
}

extension Constant {
   
    /// [比對用的NSPredicate](https://zh-tw.coderbridge.com/series/01d31194cb3c428d9ca2575c91e8b997/posts/11802227e6ad4e52b027d66f8f527f03)
    /// - Predicate.between(from: 100, to: 50).build().evaluate(with: 90)
    enum Predicate {
        
        case matches(regex: String)                 // [正則表達式 (正規式)](https://swift.gg/2019/11/19/nspredicate-objective-c/)
        case between(from: Any, to: Any)            // 區間比對 (from ~ to)
        case contain(in: Set<AnyHashable>)          // 範圍比對 (33 in [22, 33, 44] => true)
        case contains(with: String)                 // 中間包含文字 ("333GoGo3333" 包含 "GoGo")
        case begin(with: String)                    // 開頭包含文字 ("This is a Student." 開頭是 "This")
        case end(with: String)                      // 結尾包含文字 ("This is a Student." 結尾是 "Student")
        case outOfRange(from: Any, to: Any)         // 範圍之外

        /// [產生NSPredicate](https://www.jianshu.com/p/bfdacbdf37a7)
        /// - Returns: NSPredicate
        func build() -> NSPredicate {
            switch self {
            case .matches(let regex): return NSPredicate(format: "SELF MATCHES %@", regex)
            case .between(let from, let to): return NSPredicate(format: "SELF BETWEEN { \(from), \(to) }")
            case .contain(let set): return NSPredicate(format: "SELF IN %@", set)
            case .contains(let word): return NSPredicate(format: "SELF CONTAINS[cd] %@", word)
            case .begin(let word): return NSPredicate(format: "SELF BEGINSWITH[cd] %@", word)
            case .end(let word): return NSPredicate(format: "SELF ENDSWITH[cd] %@", word)
            case .outOfRange(let from, let to): return NSPredicate(format: "(SELF > \(from)) OR (SELF < \(to))")
            }
        }
    }
    
    /// 主題顏色
    enum ThemeColor {
        
        case background
        case primary
        case secondary
        case text
        case separator
        
        /// [取得顏色](https://coolors.co/palettes/trending)
        /// - Returns: UIColor?
        func color() -> UIColor? {
            
            let rgbCode: String
            
            switch self {
            case .background: rgbCode = "#a0c4ff"
            case .primary: rgbCode = "#fdffb6"
            case .secondary: rgbCode = "#ffadad"
            case .text: rgbCode = "#bdb2ff"
            case .separator: rgbCode = "#ffc6ff"
            }
            
            return UIColor(rgb: rgbCode)
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
