//
//  NicknameViewModel.swift
//  RxThreads
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel {
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
        let validText = input.text
        let validation = validText
            .orEmpty
            .map { $0.count >= 2 && $0.count <= 10}
        
        
        return Output(validText: validText, validation: validation, tap: input.tap)
    }
}
