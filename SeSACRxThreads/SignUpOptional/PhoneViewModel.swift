//
//  PhoneViewModel.swift
//  RxThreads
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    let text = Observable.just("010")
    struct Input {
        let tap: ControlEvent<Void>
        let text: ControlProperty<String?>
    }
    struct Output {
        let validText: ControlProperty<String?>
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        let text = input.text
        let validation = input.text
            .orEmpty
            .map { $0.count >= 10}
        
        return Output(validText:text , validation: validation, tap: input.tap)
    }
    
}
