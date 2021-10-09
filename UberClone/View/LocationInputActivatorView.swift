//
//  LocationInputActivatorView.swift
//  UberClone
//
//  Created by wingswift on 21/09/2021.
//

import UIKit
protocol LocationInputActivatorViewDelegate {
    func presentLocationInputView()
}

class LocationInputActivatorView: UIView {
    
    var delegate: LocationInputActivatorViewDelegate?
    
    private let placeholderLabel: UILabel = {
        let placeholder = UILabel()
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.text = "Where to?"
        placeholder.textColor = UIColor.darkGray
        placeholder.font = UIFont.systemFont(ofSize: 18)
        
        return placeholder
    }()
    
    private let indicatorView: UIImageView = {
        let image = UIImage(systemName: "stop.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.darkGray)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addTapGesture()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        self.addSubview(indicatorView)
        self.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            indicatorView.widthAnchor.constraint(equalToConstant: 7.0),
            indicatorView.heightAnchor.constraint(equalToConstant: 11.0),

            placeholderLabel.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: 16)

        ])
    }
    
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowLocationInputView))
        addGestureRecognizer(tap)
    }
    
    @objc func handleShowLocationInputView() {
        delegate?.presentLocationInputView()
    }
}

