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
enum emailError: String, Error {
    case invalidEmail = "이메일은 4자 이상 @가 포함되어야 합니다."
    case validEmail = "사용 가능한 이메일 입니다"
}
class SignUpViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let stateLabel = {
        let label = UILabel()
        return label
    }()
   
    let nextButton = PointButton(title: "다음")
    var emailData = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
            
        configureLayout()
        configure()
        bind()
    }
   
    private func bind() {
        let validText = emailTextField.rx.text
            .orEmpty
            .map { $0.count >= 4 && $0.contains("@")}
        validText
            .debug("\(validText)")
            .bind(to: nextButton.rx.isEnabled, validationButton.rx.isHidden)
            .disposed(by: disposeBag)
        validText
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemGray
                owner.nextButton.backgroundColor = color
                owner.validationButton.isHidden = !value
                owner.stateLabel.text = value ? emailError.validEmail.rawValue : emailError.invalidEmail.rawValue
                owner.stateLabel.textColor = value ? .systemGreen : .systemRed
            }
            .disposed(by: disposeBag)
        emailData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        nextButton.rx.tap
            .bind(with: self) {owner, value in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
            
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
        view.addSubview(stateLabel)
        view.addSubview(nextButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(stateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
 
import UIKit

extension UIViewController {
    
    func showAlert(t: String, msg: String, style: UIAlertController.Style, ok: String, complitionHandler: @escaping (UIAlertAction) -> Void ) {
        
        let alert = UIAlertController(title: t, message: msg, preferredStyle: style)
        
        let canel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: ok, style: .destructive, handler: complitionHandler)
        
        alert.addAction(ok)
        alert.addAction(canel)
        present(alert, animated: true, completion: nil)
        
        
    }
}
