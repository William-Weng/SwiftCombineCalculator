//
//  CalculatorViewModel.swift
//  SwiftCombineCalculator
//
//  Created by William.Weng on 2024/2/16.
//

import Combine

final class CalculatorViewModel {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Constant.TipButtonTagType, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Model.Result, Never>
        let resetCalcuatorPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancelables: Set<AnyCancellable> = []
}
