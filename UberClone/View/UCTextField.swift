//
//  UCTextField.swift
//  UberClone
//
//  Created by wingswift on 12/09/2021.
//

import UIKit

class UCTextField: UIView {
    
    var placeholder: String?
    var imageName: String!
    var isSecret: Bool?
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        
        return separator
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = isSecret ?? false
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = UIColor(white: 1, alpha: 0.8)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        
        if var image = UIImage(systemName: self.imageName) {
            image = image.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(white: 1, alpha: 0.8))
            
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
        return UIImageView(image: UIImage(systemName: "photo"))
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    init(placeholder: String, imageName: String, isSecret: Bool = false) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.imageName = imageName
        self.isSecret = isSecret
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(textField)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            
            textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            
            separatorView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}

