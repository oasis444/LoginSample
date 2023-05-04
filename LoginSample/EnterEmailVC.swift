//
//  EnterEmailVC.swift
//  LoginSample
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

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
