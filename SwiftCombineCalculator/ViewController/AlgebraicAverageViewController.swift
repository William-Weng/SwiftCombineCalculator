//
//  AlgebraicAverageViewController.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//
/// [AA制計算機](https://zh.wikipedia.org/zh-tw/AA制)

import UIKit
import Combine
import CombineCocoa
import WWPrint

// MARK: AA制計算機
final class AlgebraicAverageViewController: UIViewController {
        
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var amountPerPersonLabel: UILabel!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    @IBOutlet weak var billInputView: UIView!
    @IBOutlet weak var inputBillLabel: UILabel!
    @IBOutlet weak var billInputTextField: UITextField!

    @IBOutlet var tipButtons: [UIButton]!
    @IBOutlet var splitButtons: [UIButton]!
    
    private let radius = 16.0
    
    private let billSubject: PassthroughSubject<Double?, Never> = .init() // Subject的最大特點就是可以手動傳送資料
    private var billInputViewPublisher: AnyPublisher<Double?, Never> { return billSubject.eraseToAnyPublisher() }
    
    private var cancelables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @IBAction func calculateTip(_ sender: UIButton) {
        
        guard let type = Constant.TipButtonTagType(rawValue: sender.tag) else { return }
        
        switch type {
        case .tenPercent: wwPrint("\(type)")
        case .fiftenPercent: wwPrint("\(type)")
        case .twentyPercent: wwPrint("\(type)")
        case .custom:
            let alertControllerMaker = Utility.shared.customAlertControllerMaker { value in wwPrint(value)}
            present(alertControllerMaker, animated: true)
        }
    }
    
    @IBAction func calculatePerson(_ sender: UIButton) {
        
        guard let type = Constant.SplitButtonTagType(rawValue: sender.tag) else { return }

        switch type {
        case .plus: wwPrint("\(type)")
        case .minus: wwPrint("\(type)")
        }
    }
}

// MARK: - 小工具
private extension AlgebraicAverageViewController {
    
    /// 初始化設定
    func initSetting() {
        initViewSetting()
        resultSetting(Model.Result(amountPerPerson: 0.0, totalBill: 0.0, totalTip: 0.0))
        bind()
        observe()
    }
    
    /// 初始化畫面設定
    func initViewSetting() {
        totalView._shadow(color: .black, backgroundColor: .white, offset: CGSize(width: 8, height: 8), opacity: 0.5, radius: radius, cornerRadius: radius)
        billInputView.layer._maskedCorners(radius: radius)
        tipButtons.forEach { $0.layer._maskedCorners(radius: radius) }
        splitButtonsSetting()
    }
    
    /// 加減的按鍵設定
    func splitButtonsSetting() {
        
        splitButtons.forEach { button in
            guard let type = Constant.SplitButtonTagType(rawValue: button.tag) else { return }
            button.layer._maskedCorners(radius: radius, corners: type.corners())
        }
    }
    
    /// 計算結果
    /// - Parameter result: Model.Result
    func resultSetting(_ result: Model.Result) {
        
        let amountPerPersonText = NSMutableAttributedString(string: result.amountPerPerson._currencyFormatted(), attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 48)])
        let totalBillText = NSMutableAttributedString(string: result.totalBill._currencyFormatted(), attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 24)])
        let totalTipText = NSMutableAttributedString(string: result.totalTip._currencyFormatted(), attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 24)])
        let inputBillLabelText = NSMutableAttributedString(string: "\(amountPerPersonText.string[0])", attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 24)])
        
        amountPerPersonText.addAttributes([.font: Constant.ThemeFont.bold.font(ofSize: 24)], range: NSMakeRange(0, 1))
        totalBillText.addAttributes([.font: Constant.ThemeFont.bold.font(ofSize: 16)], range: NSMakeRange(0, 1))
        totalTipText.addAttributes([.font: Constant.ThemeFont.bold.font(ofSize: 16)], range: NSMakeRange(0, 1))
        
        amountPerPersonLabel.attributedText = amountPerPersonText
        totalBillLabel.attributedText = totalTipText
        totalTipLabel.attributedText = totalTipText
        inputBillLabel.attributedText = inputBillLabelText
    }
}

// MARK: - Combine
private extension AlgebraicAverageViewController {
    
    /// 綁定變數 (把變數指標傳過去)
    func bind() {
        
        billInputViewPublisher.sink { bill in
            let bill = bill ?? 0.0
            wwPrint("金額: \(bill)")
        }.store(in: &cancelables)
    }
}

// MARK: - CombineCocoa
private extension AlgebraicAverageViewController {
    
    /// 觀察
    func observe() {
        observeBillInputTextField()
    }
    
    /// [觀察文字輸入 => textFieldDidBeginEditing(_:)](https://developer.apple.com/documentation/uikit/uitextfielddelegate/1619590-textfielddidbeginediting)
    func observeBillInputTextField() {
        
        billInput.textPublisher.sink { [unowned self] text in
            billSubject.send(text?._Double())
        }.store(in: &cancelables)
    }
}
