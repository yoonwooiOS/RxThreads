//
//  PasswordViewModel.swift
//  RxThreads
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    
    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    struct Output {
        let validText: ControlProperty<String?>
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validText = input.text
        let validation = input.text
            .orEmpty
            .map { $0.count >= 8}
        let tap = input.tap
        
        
        
        return Output(validText: validText, validation: validation, tap: tap)
    }
}
