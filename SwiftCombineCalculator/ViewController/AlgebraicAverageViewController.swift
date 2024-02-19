//
//  AlgebraicAverageViewController.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//
/// [AA制計算機](https://zh.wikipedia.org/zh-tw/AA制)
/// [色卡](https://coolors.co/palettes/trending)
/// [CombineCocoa 是基於 Combine 對 UIKit Controls 的封裝](https://juejin.cn/post/6844903910944030727)
/// [Combine之Subjects - 知乎](https://zhuanlan.zhihu.com/p/344164793)
/// [iOS & Swift - MVVM, Combine, SnapKit, Snapshot/UI/Unit Tests](https://www.udemy.com/course/ios-swift-mvvm-combine-snapkit-snapshot-ui-unit-tests/)

import UIKit
import Combine
import CombineCocoa
import WWPrint

// MARK: AA制計算機
final class AlgebraicAverageViewController: UIViewController {
        
    @IBOutlet weak var logoView: UIStackView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var billInputView: UIView!
    @IBOutlet weak var amountPerPersonLabel: UILabel!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    @IBOutlet weak var splitCountLabel: UILabel!
    @IBOutlet weak var inputBillLabel: UILabel!
    @IBOutlet weak var billInputTextField: UITextField!

    @IBOutlet var tipButtons: [UIButton]!
    @IBOutlet var splitButtons: [MyButton]!
    
    private let radius = 16.0
    private let selectedColor: UIColor = .systemBlue
    private let unselectedColor: UIColor = .lightGray
    private let viewModel = CalculatorViewModel()

    // Subject的最大特點就是可以手動傳送資料
    private let billSubject: PassthroughSubject<Double?, Never> = .init()
    private let tipSubject: CurrentValueSubject<Constant.TipButton?, Never> = .init(nil)
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    
    // Publisher接收資料
    private var billInputValuePublisher: AnyPublisher<Double?, Never> { return billSubject.eraseToAnyPublisher() }
    private var tipValuePublisher: AnyPublisher<Constant.TipButton?, Never> { return tipSubject.eraseToAnyPublisher() }
    private var splitValuePublisher: AnyPublisher<Int, Never> { return splitSubject.eraseToAnyPublisher() }
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = viewTapPublisherMaker(forView: view)
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = viewTapPublisherMaker(numberOfTapsRequired: 2, forView: logoView)

    private var cancelables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @IBAction func calculateTip(_ sender: UIButton) { calculateTipAction(button: sender) }
}

// MARK: - 小工具
private extension AlgebraicAverageViewController {
    
    /// 初始化設定
    func initSetting() {
        initViewSetting()
        resetSpiltButtons()
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
    
    /// 利用Tag找TipButton
    /// - Parameter tag: Int?
    /// - Returns: UIButton?
    func findTipButton(tag: Int?) -> UIButton? {
        
        guard let tag = tag else { return nil }
        
        let button = tipButtons.first { $0.tag == tag }
        return button
    }
    
    /// 重新設定TipButton的背景色
    func resetTipButtons() { tipButtons.forEach { $0.backgroundColor = unselectedColor }}
    
    /// 重新設定SpiltButton的背景色
    func resetSpiltButtons() { splitButtons.forEach { $0.backgroundColor = unselectedColor }}
    
    /// 回復初始狀態
    func resetAction() {
        
        billSubject.send(nil)
        tipSubject.send(nil)
        splitSubject.send(1)
        billInputTextField.text = "0"
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.5, options: .curveEaseInOut) { [unowned self] in
            logoView.transform = .init(scaleX: 2.0, y: 2.0)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) { [unowned self] in logoView.transform = .identity }
        }
    }
    
    /// 計算結果
    /// - Parameter result: Model.Result
    func resultSetting(_ result: Model.Result) {
        
        let amountPerPersonText = NSMutableAttributedString(string: result.amountPerPerson._currencyFormatted() ?? "", attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 48)])
        let totalBillText = NSMutableAttributedString(string: result.totalBill._currencyFormatted() ?? "", attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 24)])
        let totalTipText = NSMutableAttributedString(string: result.totalTip._currencyFormatted() ?? "", attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 24)])
        let inputBillLabelText = NSMutableAttributedString(string: "\(amountPerPersonText.string[0])", attributes: [.font: Constant.ThemeFont.bold.font(ofSize: 24)])
        
        amountPerPersonText.addAttributes([.font: Constant.ThemeFont.bold.font(ofSize: 24)], range: NSMakeRange(0, 1))
        totalBillText.addAttributes([.font: Constant.ThemeFont.bold.font(ofSize: 16)], range: NSMakeRange(0, 1))
        totalTipText.addAttributes([.font: Constant.ThemeFont.bold.font(ofSize: 16)], range: NSMakeRange(0, 1))
        
        amountPerPersonLabel.attributedText = amountPerPersonText
        totalBillLabel.attributedText = totalBillText
        totalTipLabel.attributedText = totalTipText
        inputBillLabel.attributedText = inputBillLabelText
    }
}

// MARK: - 小工具
private extension AlgebraicAverageViewController {
    
    /// 取得小費設定值
    /// - Parameter button: UIButton
    func calculateTipAction(button: UIButton) {
        
        guard let type = Constant.TipButtonTagType(rawValue: button.tag) else { return }
        
        var tipButton: Constant.TipButton = (type: type, value: 0)
        
        switch type {
        case .tenPercent:
            tipButton = (type: type, value: 0.10)
            tipSubject.send(tipButton)
            
        case .fiftenPercent:
            tipButton = (type: type, value: 0.15)
            tipSubject.send(tipButton)
            
        case .twentyPercent:
            tipButton = (type: type, value: 0.20)
            tipSubject.send(tipButton)
            
        case .custom:
            
            let alertControllerMaker = Utility.shared.customAlertControllerMaker { [unowned self] value in
                tipButton = (type: type, value: Double(value))
                tipSubject.send(tipButton)
            }
            
            present(alertControllerMaker, animated: true)
        }
    }
}

// MARK: - Combine
private extension AlgebraicAverageViewController {
    
    /// 綁定變數 (把變數指標傳過去)
    func bind() {
        
        bindInputValuePublisher()
        splitButtons.forEach { bindSplitCount(button: $0) }
        
        let input = CalculatorViewModel.Input(
            billPublisher: billInputValuePublisher,
            tipPublisher: tipValuePublisher,
            splitPublisher: splitValuePublisher,
            logoViewTapPublisher: logoViewTapPublisher
        )
        
        let output = viewModel.transform(input: input)

        output.updateViewPublisher.sink { [unowned self] result in
            resultSetting(result)
            wwPrint("\(result)")
        }.store(in: &cancelables)
        
        output.resetCalcuatorPublisher.sink { [unowned self] _ in
            resetAction()
        }.store(in: &cancelables)
    }
    
    /// 綁定金額
    func bindInputValuePublisher() {
        
        billInputValuePublisher.sink { bill in
            let bill = bill ?? 0.0
            wwPrint("金額: \(bill)")
        }.store(in: &cancelables)
    }
    
    /// 綁定人數 (存在數值裡面)
    /// - Parameter button: UIButton
    func bindSplitCount(button: UIButton) {
        
        guard let type = Constant.SplitButtonTagType(rawValue: button.tag) else { return }
        
        button.tapPublisher.flatMap { [unowned self] _ in
            
            var value: Int = splitSubject.value
            
            switch type {
            case .plus: value += 1
            case .minus: value -= 1
            }
            
            if (value < 1) { value = 1 }
            
            return Just(value)
            
        }.assign(to: \.value, on: splitSubject)
        .store(in: &cancelables)
    }
}

// MARK: - Publisher
private extension AlgebraicAverageViewController {
    
    /// 產生View的Publisher
    /// - Parameters:
    ///   - numberOfTapsRequired: Int
    ///   - view: UIView
    /// - Returns: AnyPublisher<Void, Never>
    func viewTapPublisherMaker(numberOfTapsRequired: Int = 1, forView view: UIView) -> AnyPublisher<Void, Never> {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        view.addGestureRecognizer(tapGesture)
        
        return tapGesture.tapPublisher.flatMap { _ in Just(()) }.eraseToAnyPublisher()
    }
}

// MARK: - CombineCocoa
private extension AlgebraicAverageViewController {
    
    /// 觀察
    func observe() {
        observeBillInputTextField()
        observeTipValue()
        observeSplitCountLabel()
        observeView()
        observeLogoView()
    }
    
    /// [觀察文字輸入 => textFieldDidBeginEditing(_:)](https://developer.apple.com/documentation/uikit/uitextfielddelegate/1619590-textfielddidbeginediting)
    func observeBillInputTextField() {
        
        billInputTextField.textPublisher.sink { [unowned self] text in
            billSubject.send(text?._Double())
        }.store(in: &cancelables)
    }
    
    /// 觀察Tip按鍵被按
    func observeTipValue() {
        
        tipSubject.sink { [unowned self] tipButton in
            
            resetTipButtons()
            
            guard let tipButton = tipButton,
                  let button = findTipButton(tag: tipButton.type?.rawValue)
            else {
                return
            }
            
            button.backgroundColor = selectedColor
            wwPrint(tipButton.value)
            
        }.store(in: &cancelables)
    }
    
    /// 觀察人數的按鍵被按
    func observeSplitCountLabel() {
        
        splitSubject.sink { [unowned self] quantity in
            splitCountLabel.text = "\(quantity)"
        }.store(in: &cancelables)
    }
    
    /// 觀察View被按
    func observeView() {
        
        viewTapPublisher.sink { [unowned self] _ in
            view.endEditing(true)
        }.store(in: &cancelables)
    }
    
    /// 觀察LogoView被按
    func observeLogoView() {
        
        logoViewTapPublisher.sink { [unowned self] _ in
            resetAction()
        }.store(in: &cancelables)
    }
}
