//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxCocoa
import RxSwift
final class PhoneViewController: UIViewController {
    private let phoneTextField = {
        let textField = SignTextField(placeholderText: "연락처를 입력해주세요")
        textField.keyboardType = .decimalPad
        return textField
    }()
    let phoneNumverValidStateLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    let validText = PublishSubject<String>()
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
    }
    private func bind() {
        let input = PhoneViewModel.Input(tap: nextButton.rx.tap, text: phoneTextField.rx.text)
        let output = viewModel.transform(input: input)
        
        viewModel.text
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
       
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemGray
                owner.nextButton.backgroundColor = color
                owner.phoneNumverValidStateLabel.text = value ? ValidText.phoneNumberError.validNumber.rawValue : ValidText.phoneNumberError.invalidNumber.rawValue
                owner.phoneNumverValidStateLabel.textColor = value ? .systemGreen : .systemRed
            }
            .disposed(by: disposeBag)
        output.tap
            .bind(with: self) { owner, value in
                print("sdsa")
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(phoneNumverValidStateLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        phoneNumverValidStateLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneNumverValidStateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
