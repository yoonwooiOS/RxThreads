//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let nicknameStateLabel = UILabel()
    let viewModel = NicknameViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    private func bind() {
        let input = NicknameViewModel.Input(tap: nextButton.rx.tap, text: nicknameTextField.rx.text)
        let output = viewModel.transform(input: input)
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        output.validation
            .bind(with: self) { owner, value in
                let nicknameStateLabelColor: UIColor = value ? .systemGreen : .systemRed
                let nextButtonColor: UIColor = !value ? .systemGray : .systemBlue
                owner.nicknameStateLabel.textColor = nicknameStateLabelColor
                owner.nicknameStateLabel.text = value ? ValidText.nicknameError.validNickname.rawValue : ValidText.nicknameError.invalidNickname.rawValue
                owner.nextButton.backgroundColor = nextButtonColor
            }
            .disposed(by: disposeBag)
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStateLabel)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nicknameStateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameStateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
