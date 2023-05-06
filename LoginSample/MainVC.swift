//
//  MainVC.swift
//  LoginSample
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import FirebaseAuth

class MainVC: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        guard let email = Auth.auth().currentUser?.email else { return }
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
    @IBAction func profileUpdateButtonTapped(_ sender: UIButton) {
        let changeRequeset = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequeset?.displayName = "oasis444"
        changeRequeset?.commitChanges { _ in
            let displayName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "고객"
            self.welcomeLabel.text = """
            환영합니다.
            \(displayName)님
            """
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error: singOut \(signOutError)")
        }
    }
    
    private func configure() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !isEmailSignIn
    }
}
