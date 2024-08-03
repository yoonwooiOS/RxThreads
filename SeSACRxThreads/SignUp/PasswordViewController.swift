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
class PasswordViewController: UIViewController {
   
    private let passwordTextField = {
        let textField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
        
        textField.keyboardType = .decimalPad
        return textField
    }()
 
    let nextButton = PointButton(title: "다음")
    let validText = PublishSubject<String>()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
    }
    private func bind() {
        passwordTextField.rx.text.onNext("010")
        let validation = passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= 10}
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemGray
                owner.nextButton.backgroundColor = color
                
            }
            .disposed(by: disposeBag)
        nextButton.rx.tap
            .bind(with: self) { owner, value in
                print("sdsa")
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
   
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
