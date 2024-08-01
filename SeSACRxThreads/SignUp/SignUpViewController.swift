//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/*
 emailTextField에 글자를 입력한다
 email 검증을 한다
 검증에 통과되면 다음 버튼을 눌러서 화면 이동을 한다
 */

class SignUpViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bind()
    }
    private func bind() {
        let textvalid = emailTextField.rx.text.orEmpty
            .map { $0.count >= 4}
        print(textvalid)
        
        let textValidate = BehaviorSubject(value: false) // 검증된 값을 담아줄 Observable 생성
        emailTextField.rx.text.orEmpty // emailTextField.rx.text emailTextField에 입력된 값을 가지고 온다 | orEmpty 사용시 값이 nil일 경우 "" 출력
            .bind(with: self) { owner, text in // subscribe 시점 -> 하지만 textFiled는 error나 complete가 필요 없기 때문에 bind로 구독
                if text.contains("@")  {
                    textValidate.onNext(true)
                } else {
                    textValidate.onNext(false)
                }
            }
            
        
        textValidate
            .bind(with: self) { owner, valid in // subscribe 시점 -> textValidate가 바뀌면 적용할 일
            if valid {
                print("이메일 검증이 성공했습니다.")
            } else {
                print("다시 입력해주세요")
            }
        }
        .disposed(by: disposeBag)
    }
    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
 
