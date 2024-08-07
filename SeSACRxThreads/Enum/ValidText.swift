//
//  ValidText.swift
//  RxThreads
//
//  Created by 김윤우 on 8/3/24.
//

import Foundation

enum ValidText {
    enum emailError: String, Error {
        case invalidEmail = "이메일은 4자 이상 @가 포함되어야 합니다."
        case validEmail = "사용 가능한 이메일 입니다"
    }
    enum passwordError: String, Error {
        case invalidPassword = "비밀번호는 8글자 이상입니다"
        case validPassword = "사용 가능한 비밀번호 입니다"
    }
    enum phoneNumberError: String, Error {
        case invalidNumber = "휴대폰 번호는 10글자 이상입니다"
        case validNumber = "올바른 번호 입니다"
    }
    enum BirthdayError: String, Error {
        case invalidBirthday = "만 17세 이상만 가입 가능합니다."
        case validBirthDay = "가입 가능합니다."
    }
    enum nicknameError: String, Error {
        case invalidNickname = "닉네임은 2글자 이상 10글자 이하입니다."
        case validNickname = "사용하능한 닉네임입니다."
    }
}
