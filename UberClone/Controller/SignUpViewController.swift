//
//  SignUpViewController.swift
//  UberClone
//
//  Created by wingswift on 18/09/2021.
//

import UIKit
import Firebase
import GeoFire

class SignUpViewController: UIViewController {
    var location: CLLocation? = LocationHandler.shared.locationManager.location
    
    private let logoLabel = ViewFactory.makeLogo()
    private let emailTextField = UCTextField(placeholder: "Email", imageName: "envelope")
    private let fullNameTextField = UCTextField(placeholder: "Full Name", imageName: "person")
    private let passwordTextField = UCTextField(placeholder: "Password", imageName: "lock", isSecret: true)
    private let segmentedControll = ViewFactory.createSegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        configureLogo()
        configureSignUpForm()
        configureLogInLinkButton()
        
    }
    
    @objc func goToLogInPage() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.textField.text, emailTextField.textField.text?.isEmpty == false else { return }
        guard let password = passwordTextField.textField.text else { return }
        guard let fullName = fullNameTextField.textField.text else { return }
        let accountType = segmentedControll.selectedSegmentIndex
        
        print(email, password, fullName, accountType)
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("failed to register user with error: \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email, "fullName": fullName, "accountType": accountType] as [String : Any]
            
            if accountType == 1 {
                guard let location = self.location else { return }
                
                let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                geofire.setLocation(location, forKey: uid) { _ in
                    self.uploadUserDataAndShowHomeController(uid: uid, values: values)
                }
            } else {
                self.uploadUserDataAndShowHomeController(uid: uid, values: values)
            }
        }
    }
    
    
    func uploadUserDataAndShowHomeController(uid: String, values: [String: Any]) {
        
        REF_USERS.child(uid).updateChildValues(values) { error, ref in
            print("successfully registed user and save data")
            
            guard let homeController = UIApplication.shared.keyWindow?.rootViewController as? HomeViewController else { return }
            homeController.configureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func configureLogo() {
        view.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    
    func configureSignUpForm() {
        let signUpFormView = UIStackView()
        signUpFormView.translatesAutoresizingMaskIntoConstraints = false
        signUpFormView.axis = .vertical
        signUpFormView.spacing = 16
        view.addSubview(signUpFormView)
        
        signUpFormView.addArrangedSubview(emailTextField)
        signUpFormView.addArrangedSubview(fullNameTextField)
        signUpFormView.addArrangedSubview(passwordTextField)
        
        
        let signUpButton = ViewFactory.createPrimaryButton(title: "Sign Up")
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        signUpFormView.addArrangedSubview(segmentedControll)
        signUpFormView.addArrangedSubview(signUpButton)
        
        
        NSLayoutConstraint.activate([
            signUpFormView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 32),
            signUpFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signUpFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
    }
    
    
    func configureLogInLinkButton() {
        let logInLinkButton = ViewFactory.createLinkButton(normalText: "Already have an account? ", linkText: "Sign In")
        view.addSubview(logInLinkButton)
        
        NSLayoutConstraint.activate([
            logInLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logInLinkButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        logInLinkButton.addTarget(self, action: #selector(goToLogInPage), for: .touchUpInside)
        
    }
}
