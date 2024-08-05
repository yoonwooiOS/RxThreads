//
//  BirthdayViewModel.swift
//  RxThreads
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    lazy var year = BehaviorRelay(value: yearDateFormatter())
    lazy var month = BehaviorRelay(value: monthDateFormatter())
    lazy var day = BehaviorRelay(value: todayDateFormatter())
    
    struct Input {
        let tap: ControlEvent<Void>
        var date: ControlProperty<Date>
    }
    struct Output {
        let tap: ControlEvent<Void>
        let validation: Observable<Bool>
        let date: ControlProperty<Date>
        var year: BehaviorRelay <Int>
        var month: BehaviorRelay <Int>
        var day: BehaviorRelay <Int>
        
    }
    
    func transform(input: Input) -> Output {
        let validation = Observable.combineLatest(year, month, day) {
            year, month, day in
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            let birthday = Calendar.current.date(from: components)!
            let currentDate = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: currentDate)
            let age = ageComponents.year!
            return age >= 17
                        
        }
        return Output(tap: input.tap, validation: validation, date: input.date, year: year, month: month, day: day)
       
    }
    func yearDateFormatter() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let thisYear = formatter.string(from: Date())
        guard let thisYear = Int(thisYear) else {
            print("monthDateFormatter Error")
            return 0
        }
        return thisYear
    }
    func monthDateFormatter() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let thisMonth = formatter.string(from: Date())
        guard let thisMonth = Int(thisMonth) else {
            print("monthDateFormatter Error")
            return 0
        }
        return thisMonth
    }
    func todayDateFormatter() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let today = formatter.string(from: Date())
        guard let today = Int(today) else {
            print("todayDateFormatter Error")
            return 0
        }
        return today
    }
}
