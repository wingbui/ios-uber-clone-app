//
//  RideActionView.swift
//  UberClone
//
//  Created by wingswift on 02/10/2021.
//

import UIKit
import MapKit

protocol RideActionViewDelegate {
    func uploadTrip(_ view: RideActionView)
}

class RideActionView: UIView {
    
    let placeTitle = ViewFactory.createLabel(text: "")
    let addressTitle = ViewFactory.createLabel(text: "")
    let separatorView = ViewFactory.createSeparatorView()
    let bookButton = ViewFactory.createPrimaryButton(title: "CONFIRM UBERX")
    let uberXLabel = ViewFactory.createLabel(text: "UberX")
    var delegate: RideActionViewDelegate?
    
    var destination: MKPlacemark? {
        didSet {
            placeTitle.text = destination?.name
            addressTitle.text = destination?.title
        }
    }
    
    var uberXView: UIView = {
        let xLabel = ViewFactory.createLabel(text: "X")
        xLabel.textColor = .white
        xLabel.font = UIFont.systemFont(ofSize: 28)
        
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(xLabel)
        
        NSLayoutConstraint.activate([
            xLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            xLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureUberxView()
        configureUberXLabel()
        configureSeparatorView()
        configureBookButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        layer.shadowOpacity = 0.55
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        placeTitle.textColor = .darkGray
        placeTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        placeTitle.numberOfLines = 0
        placeTitle.lineBreakMode = .byWordWrapping
        placeTitle.minimumScaleFactor = 0.5
        placeTitle.textAlignment = .center
        
        addressTitle.textColor = .lightGray
        addressTitle.numberOfLines = 0
        addressTitle.lineBreakMode = .byWordWrapping
        addressTitle.minimumScaleFactor = 0.5
        addressTitle.textAlignment = .center
        
        addSubview(placeTitle)
        addSubview(addressTitle)
        
        NSLayoutConstraint.activate([
            placeTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            placeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            placeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            addressTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            addressTitle.topAnchor.constraint(equalTo: placeTitle.bottomAnchor, constant: 12),
            addressTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            addressTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    
    func configureUberxView() {
        addSubview(uberXView)
        
        NSLayoutConstraint.activate([
            uberXView.centerXAnchor.constraint(equalTo: centerXAnchor),
            uberXView.heightAnchor.constraint(equalToConstant: 60),
            uberXView.widthAnchor.constraint(equalToConstant: 60),
            uberXView.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 12)
        ])
        
    }
    
    func configureUberXLabel() {
        addSubview(uberXLabel)
        
        NSLayoutConstraint.activate([
            uberXLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            uberXLabel.topAnchor.constraint(equalTo: uberXView.bottomAnchor, constant: 10)
        ])
    }
    
    
    func configureSeparatorView() {
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: uberXLabel.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    
    func configureBookButton() {
        addSubview(bookButton)
        bookButton.backgroundColor = .black
        bookButton.addTarget(self, action: #selector(confirmUberX), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            bookButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            bookButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bookButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bookButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func confirmUberX() {
        delegate?.uploadTrip(self)
    }
}

