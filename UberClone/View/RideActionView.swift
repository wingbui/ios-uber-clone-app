//
//  RideActionView.swift
//  UberClone
//
//  Created by wingswift on 02/10/2021.
//

import UIKit
import MapKit

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case pickupPassenger
    case driverArrived
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide: return "CONFIRM UBERX"
        case .cancel: return "CANCEL RIDE"
        case .getDirections: return "GET DIRECTIONS"
        case .pickup: return "PICKUP PASSENGER"
        case .dropOff: return "DROP OFF PASSENGER"
        }
    }
    
    init() {
        self = .requestRide
    }
}

protocol RideActionViewDelegate {
    func uploadTrip(_ view: RideActionView)
    func cancelTrip()
    func pickUpPassenger()
    func dropOffPassenger()
}

class RideActionView: UIView {
    
    var config = RideActionViewConfiguration() {
        didSet {
            self.configureUI(withConfig: config)
        }
    }
    
    var buttonAction = ButtonAction()
    let placeTitle = ViewFactory.createLabel(text: "")
    let addressTitle = ViewFactory.createLabel(text: "")
    let separatorView = ViewFactory.createSeparatorView()
    let actionButton = ViewFactory.createPrimaryButton(title: ButtonAction.requestRide.description)
    let uberXLabel = ViewFactory.createLabel(text: "UberX")
    var delegate: RideActionViewDelegate?
    var destination: MKPlacemark? {
        didSet {
            placeTitle.text = destination?.name
            addressTitle.text = destination?.title
        }
    }
    var user: User?
    
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
        configurePlaceTitle()
        configureAddressTitle()
        configureUberxView()
        configureUberXLabel()
        configureSeparatorView()
        configureActionButton()
        
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
    }
    
    
    func configureUI(withConfig config: RideActionViewConfiguration) {
        switch config {
        case .requestRide:
            buttonAction = .requestRide
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .tripAccepted:
            guard let user = user else { return }
            
            if user.accountType == .passenger {
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description , for: .normal)
                placeTitle.text = "En Route To Passenger"
                addressTitle.text = user.fullName
            } else {
                buttonAction = .cancel
                actionButton.setTitle(buttonAction.description , for: .normal)
                placeTitle.text = "Driver On Route"
                addressTitle.text = user.fullName
            }
        case .pickupPassenger:
            buttonAction = .pickup
            actionButton.setTitle(buttonAction.description, for: .normal)
            placeTitle.text = "Driver arrived at the passenger's area"
        case .driverArrived:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                placeTitle.text = "Driver has arrived"
                addressTitle.text = "Please meet the driver at the pickup location"
            }
        case .tripInProgress:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                print("driver")
                actionButton.setTitle("TRIP IN PROGRESS", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            addressTitle.text = "En Route To Destination"
        case .endTrip:
            guard let user = user else { return }
            
            if user.accountType == .passenger {
                buttonAction = .dropOff
                actionButton.setTitle(buttonAction.description, for: .normal)
            } else {
                actionButton.setTitle("ARRIVED AT DESTINATION", for: .normal)
            }
            break
        }
    }
    
    
    func configurePlaceTitle() {
        placeTitle.textColor = .darkGray
        placeTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        placeTitle.numberOfLines = 0
        placeTitle.lineBreakMode = .byWordWrapping
        placeTitle.minimumScaleFactor = 0.5
        placeTitle.textAlignment = .center
        
        addSubview(placeTitle)
        
        NSLayoutConstraint.activate([
            placeTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            placeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            placeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    
    func configureAddressTitle() {
        addressTitle.textColor = .lightGray
        addressTitle.numberOfLines = 0
        addressTitle.lineBreakMode = .byWordWrapping
        addressTitle.minimumScaleFactor = 0.5
        addressTitle.textAlignment = .center
        
        addSubview(addressTitle)
        
        NSLayoutConstraint.activate([
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
    
    
    func configureActionButton() {
        addSubview(actionButton)
        actionButton.backgroundColor = .black
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    @objc func actionButtonPressed() {
        
        switch buttonAction {
        case .requestRide:
            delegate?.uploadTrip(self)
            break;
        case .cancel:
            delegate?.cancelTrip()
            break;
        case .getDirections:
            break;
        case .pickup:
            delegate?.pickUpPassenger()
        case .dropOff:
            delegate?.dropOffPassenger()
        }
    }
}

