//
//  LocationInputView.swift
//  UberClone
//
//  Created by wingswift on 22/09/2021.
//

import UIKit

protocol LocationInputViewDelegate {
    func dismissLocationInputView()
    func executeSearch(naturalLanguage: String)
}

class LocationInputView: UIView {
    
    var delegate: LocationInputViewDelegate?
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.fullName
        }
    }
    
    let backButton: UIButton = {
        let image = UIImage(systemName: "arrow.backward")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor.black)
        
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(handleDismissLocationInputView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var userNameLabel =  ViewFactory.createLabel(text: "...Loading")
    
    let startPointView = ViewFactory.createPointView()
    let endPointView = ViewFactory.createPointView()
    let linkingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let startPointTextField = ViewFactory.createTextField()
    let endPointTextField = ViewFactory.createTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureStartPointView()
        configureEndPointView()
        configureLinkingView()
        configureStartPointTextField()
        configureEndPointTextField()
        configureUserNameLabel()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        layer.shadowOpacity = 0.55
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 44),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
        ])
    }
    
    
    func configureStartPointView() {
        addSubview(startPointView)
        startPointView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            startPointView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            startPointView.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            startPointView.heightAnchor.constraint(equalToConstant: 6),
            startPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    func configureEndPointView() {
        addSubview(endPointView)
        endPointView.backgroundColor = .black
        endPointTextField.delegate = self
        
        NSLayoutConstraint.activate([
            endPointView.topAnchor.constraint(equalTo: startPointView.bottomAnchor, constant: 32),
            endPointView.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            endPointView.heightAnchor.constraint(equalToConstant: 6),
            endPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    func configureLinkingView() {
        addSubview(linkingView)
        linkingView.backgroundColor = .darkGray
        
        NSLayoutConstraint.activate([
            linkingView.topAnchor.constraint(equalTo: startPointView.bottomAnchor, constant: 1.5),
            linkingView.bottomAnchor.constraint(equalTo: endPointView.topAnchor, constant: -1.5),
            linkingView.centerXAnchor.constraint(equalTo: startPointView.centerXAnchor),
            linkingView.widthAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureStartPointTextField() {
        addSubview(startPointTextField)
        
        startPointTextField.backgroundColor = .groupTableViewBackground
        startPointTextField.font = UIFont.systemFont(ofSize: 16)
        startPointTextField.placeholder = "Current destination"
        
        let paddingView = UIView()
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
        startPointTextField.leftView = paddingView
        startPointTextField.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            startPointTextField.centerYAnchor.constraint(equalTo: startPointView.centerYAnchor),
            startPointTextField.leadingAnchor.constraint(equalTo: startPointView.trailingAnchor, constant: 16),
            startPointTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            startPointTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configureEndPointTextField() {
        addSubview(endPointTextField)
        
        endPointTextField.backgroundColor = .lightGray
        endPointTextField.font = UIFont.systemFont(ofSize: 16)
        endPointTextField.placeholder = "Enter a destination"
        
        let paddingView = UIView()
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
        endPointTextField.leftView = paddingView
        endPointTextField.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            endPointTextField.centerYAnchor.constraint(equalTo: endPointView.centerYAnchor),
            endPointTextField.leadingAnchor.constraint(equalTo: endPointView.trailingAnchor, constant: 16),
            endPointTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            endPointTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    func configureUserNameLabel() {
        addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }
    
    
    @objc func handleDismissLocationInputView() {
        delegate?.dismissLocationInputView()
    }
    
}

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else { return false }
        
        self.delegate?.executeSearch(naturalLanguage: query)
        return true
    }
}
