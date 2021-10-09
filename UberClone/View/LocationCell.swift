//
//  LocationCell.swift
//  UberClone
//
//  Created by wingswift on 24/09/2021.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    var placemark: MKPlacemark? {
        didSet {
            titleLabel.text = placemark?.name
            addressLabel.text = placemark?.title
        }
    }
    
    private let titleLabel = ViewFactory.createLabel(text: "placeholder")
    private let addressLabel = ViewFactory.createLabel(text: "placeholder")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        titleLabel.textColor = .darkGray
        addressLabel.textColor = .lightGray
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        addressLabel.minimumScaleFactor = 0.5
        addressLabel.allowsDefaultTighteningForTruncation = true
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 4
        sv.distribution = .fillEqually
        self.addSubview(sv)
        
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
