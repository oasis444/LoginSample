//
//  EnterEmailVC.swift
//  LoginSample
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import FirebaseAuth

class EnterEmailVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nextButton.layer.cornerRadius = 30
        errorMessageLabel.isHidden = true
        nextButton.isEnabled = false
        
        emailTextField.becomeFirstResponder() // emailTextField에 자동적으로 커서가 오게 하도록 설정
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "이메일/비밀번호 입력하기"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // 화면 터치 시 키보드 내리기
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때
                    self.loginUser(email: email, password: password) // 로그인하기

                default:
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = error.localizedDescription
                }
            }
            else {
                self.showMainViewController()
            }
        }
    }
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController() {
        guard let vc = storyboard?.instantiateViewController(identifier: "MainVC") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EnterEmailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let isEmailEmpty = emailTextField.text?.isEmpty else { return }
        guard let isPasswordEmpty = passwordTextField.text?.isEmpty else { return }
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}
