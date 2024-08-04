//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "\(year)년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "\(month)월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "\(day)일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = {
        let button = PointButton(title: "가입하기")
        button.isEnabled = false
        return button
    }()
    
    let disposBag = DisposeBag()
    lazy var year = BehaviorRelay(value: yearDateFormatter())
    lazy var month = BehaviorRelay(value: monthDateFormatter())
    lazy var day = BehaviorRelay(value: todayDateFormatter())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    private func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                print("날짜 바뀜 \(date)")
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
            }
            .disposed(by: disposBag)
        year
            .map { "\($0)년"}
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposBag)
        month
            .map { "\($0)월"}
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposBag)
        day
            .map { "\($0)일"}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposBag)
        
        let validation = Observable.combineLatest(year, month, day) { year, month, day in
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
        validation
            .map {$0 ? ValidText.BirthdayError.validBirthDay.rawValue :   ValidText.BirthdayError.invalidBirthday.rawValue }
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposBag)
        validation
            .bind(with: self) { owner, value in
                let infoLabelColor: UIColor = value ? .systemGreen : .systemRed
                let nextButtonColor: UIColor = value ? .systemBlue : .systemGray
                owner.infoLabel.textColor = infoLabelColor
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = nextButtonColor
            }
            .disposed(by: disposBag)
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}

extension BirthdayViewController {
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
