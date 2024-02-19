//
//  CalculatorViewModel.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import Combine
import WWPrint

final class CalculatorViewModel {
    
    struct Input {
        let billPublisher: AnyPublisher<Double?, Never>
        let tipPublisher: AnyPublisher<Constant.TipButton?, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Model.Result, Never>
        let resetCalcuatorPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancelables: Set<AnyCancellable> = []
}

extension CalculatorViewModel {
    
    /// input => output
    /// - Parameter input: Input
    /// - Returns: Output
    func transform(input: Input) -> Output {
        
        let updateViewPublisher = Publishers.CombineLatest3(input.billPublisher, input.tipPublisher, input.splitPublisher).flatMap { [unowned self] (bill, tipButton, split) in
            
            let totalTip = tipAmount(bill: bill, tipButton: tipButton)
            let totalBill = bill ?? 0 + totalTip
            let amountPerPerson = totalBill / Double(split)
            let result = Model.Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip)

            return Just(result)
            
        }.eraseToAnyPublisher()
        
        
        let resultCalcuatorPublisher = input.logoViewTapPublisher.handleEvents(receiveOutput: {
            wwPrint("")
        }).flatMap {
            return Just($0)
        }
        
        let output = Output(
            updateViewPublisher: updateViewPublisher,
            resetCalcuatorPublisher: resultCalcuatorPublisher.eraseToAnyPublisher())
        
        return output
    }
    
    /// 小費計算
    /// - Parameters:
    ///   - bill: Double?
    ///   - tipButton: Constant.TipButton?
    /// - Returns: Double
    func tipAmount(bill: Double?, tipButton: Constant.TipButton?) -> Double {
        
        guard let bill = bill,
              let tipButton = tipButton
        else {
            return 0
        }
        
        switch tipButton.type {
        case .none: return 0
        case .tenPercent, .fiftenPercent, .twentyPercent: return bill * tipButton.value
        case .custom: return tipButton.value
        }
    }
}
