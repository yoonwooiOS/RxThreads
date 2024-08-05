//
//  SignUpViewModel.swift
//  RxThreads
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    struct Output {
        let tap: ControlEvent<Void>
        let validText: ControlProperty<String?>
        let validation: Observable<Bool>
    }
    
    
    func transfrom(input: Input) -> Output {
        let validText = input.text
        let validation = input.text
            .orEmpty
            .map { $0.count >= 4 && $0.contains("@")}
        
        return Output(tap: input.tap, validText: validText, validation: validation)
    }
    
    
}
