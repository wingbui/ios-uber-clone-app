//
//  UIViewController+Ext.swift
//  UberClone
//
//  Created by wingswift on 11/10/2021.
//

import UIKit

extension UIViewController {
    
    func presentAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func shouldPresentLoadingView(presenting: Bool, message: String? = nil) {
        if presenting {
            let loadingView = UIView()
            loadingView.alpha = 0
            loadingView.tag = 1
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.backgroundColor = .black
            self.view.addSubview(loadingView)
            
            let indicator = UIActivityIndicatorView()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.style = .large
            indicator.color = .white
            loadingView.addSubview(indicator)
            
            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                indicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
                indicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            ])
            
            if let message = message {
                let label = ViewFactory.createLabel(text: message)
                label.textColor = .white
                loadingView.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: indicator.centerXAnchor),
                    label.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 8)
                ])
                
            }
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.1) {
                loadingView.alpha = 0.7
            }
        } else {
            self.view.subviews.forEach { subview in
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.2, animations:{
                        subview.alpha = 0
                    }, completion: { _ in
                        subview.removeFromSuperview()
                    })
                }
            }
        }
    }
}
