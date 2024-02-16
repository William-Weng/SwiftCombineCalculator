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
    
    /// 自訂小費的Alert
    /// - Parameter completion: (Int) -> Void
    /// - Returns: UIAlertController
    func customAlertControllerMaker(completion: @escaping (Int) -> Void) -> UIAlertController {
        
        let alertController = UIAlertController(title: "請輸入自訂小費", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textFiled in
            textFiled.placeholder = "不要客氣啊"
            textFiled.keyboardType = .numberPad
            textFiled.autocapitalizationType = .none
        }
                
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let textField = alertController.textFields?.first,
                  let text = textField.text,
                  let value = text._Int()
            else {
                return
            }
            
            completion(value)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [okAction, cancelAction].forEach(alertController.addAction(_:))
        return alertController
    }
}
