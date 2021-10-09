//
//  LoginViewController.swift
//  UberClone
//
//  Created by wingswift on 11/09/2021.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    var homeVC: HomeViewController?
    private let emailTextField = UCTextField(placeholder: "Email", imageName: "envelope")
    private let passwordTextField = UCTextField(placeholder: "Password", imageName: "lock", isSecret: true)
    
     private let logoLabel = ViewFactory.makeLogo()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        configureNavigationBar()
        configureLogo()
        configureLoginForm()
        configureSignUpLinkButton()
    }
    
    
    @objc func goToSignUpPage() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    
    @objc func handleLogIn() {
        guard let email = emailTextField.textField.text else { return }
        guard let password = passwordTextField.textField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Debug: Failed to log user in with error: \(error)")
                return
            }
            self.dismiss(animated: true) {
                self.homeVC?.configureUI()
            }
        }
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureLogo() {
        view.addSubview(logoLabel)
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func configureLoginForm() {
        
        let logInFormView = UIStackView()
        logInFormView.translatesAutoresizingMaskIntoConstraints = false
        logInFormView.axis = .vertical
        logInFormView.spacing = 16
        view.addSubview(logInFormView)
        
        logInFormView.addArrangedSubview(emailTextField)
        logInFormView.addArrangedSubview(passwordTextField)
        
        let logInButton = ViewFactory.createPrimaryButton(title: "Log In")
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        logInFormView.addArrangedSubview(logInButton)
        
        NSLayoutConstraint.activate([
            logInFormView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 32),
            logInFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureSignUpLinkButton() {
        let signUpLinkButton = ViewFactory.createLinkButton(normalText: "Don't have an account? ", linkText: "Sign Up")
        view.addSubview(signUpLinkButton)
        
        NSLayoutConstraint.activate([
            signUpLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signUpLinkButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        signUpLinkButton.addTarget(self, action: #selector(goToSignUpPage), for: .touchUpInside)
        
    }
}

