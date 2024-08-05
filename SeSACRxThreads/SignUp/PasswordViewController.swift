//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
//
final class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let stateLabel = UILabel()
    let validText = PublishSubject<String>()
    let viewModel = PasswordViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
    }
    private func bind() {
        let input = PasswordViewModel.Input(text: passwordTextField.rx.text, tap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        
        output.validText
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemGray
                owner.nextButton.backgroundColor = color
                owner.stateLabel.text = value ? ValidText.passwordError.validPassword.rawValue : ValidText.passwordError.invalidPassword.rawValue
                owner.stateLabel.textColor = value ? .systemGreen : .systemRed
            }
            .disposed(by: disposeBag)
        output.tap
            .bind(with: self) { onwner, _ in
                onwner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(stateLabel)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)

        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(stateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
