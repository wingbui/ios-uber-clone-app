//
//  ContainerViewController.swift
//  UberClone
//
//  Created by wingswift on 31/10/2021.
//

import UIKit

class ContainerViewController: UIViewController {
    private let homeVC = HomeViewController()
    private let menuVC = MenuViewController()
    fileprivate var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeVC()
        configureMenuVC()
    }
    
    func configureHomeVC() {
        addChild(homeVC)
        homeVC.didMove(toParent: self)
        view.addSubview(homeVC.view)
        homeVC.delegate = self
    }
    
    func configureMenuVC() {
        addChild(menuVC)
        menuVC.didMove(toParent: self)
        view.insertSubview(menuVC.view, at: 0)
    }
    
    func animateMenu(shouldExpand: Bool) {
        if shouldExpand {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: { self.homeVC.view.frame.origin.x = self.view.frame.width - 80 },
                completion: nil
            )
        } else {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: { self.homeVC.view.frame.origin.x = 0 },
                completion: nil
            )
        }
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func slideRight() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}
