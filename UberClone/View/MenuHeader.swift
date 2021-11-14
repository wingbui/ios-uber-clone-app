//
//  MenuHeader.swift
//  UberClone
//
//  Created by wingswift on 01/11/2021.
//

import UIKit

class MenuHeader: UIView {
    let user: User
    
    private var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var nameLabel = ViewFactory.createLabel(text: "loading...")
    
    private var emailLabel = ViewFactory.createLabel(text: "loading...")
    
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        configureProfileImageView()
        configureNameAndEmailLabels()
    }
    
    func configureProfileImageView() {
        profileImageView.layer.cornerRadius = 64/2
        profileImageView.backgroundColor = .lightGray
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -60),
            profileImageView.heightAnchor.constraint(equalToConstant: 64),
            profileImageView.widthAnchor.constraint(equalToConstant: 64),
        ])
    }
    
    func configureNameAndEmailLabels() {
        configureNameLabel()
        configureEmailLabel()
        configureNameAndEmailIntoStack()
    }
    
    fileprivate func configureNameAndEmailIntoStack() {
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16)
        ])
    }
    
    fileprivate func configureNameLabel() {
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.text = user.fullName
    }
    
    
    fileprivate func configureEmailLabel() {
        emailLabel.textColor = .lightGray
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.text = user.email
    }
}
