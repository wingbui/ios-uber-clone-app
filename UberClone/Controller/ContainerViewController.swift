//
//  ContainerViewController.swift
//  UberClone
//
//  Created by wingswift on 31/10/2021.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {
    private let homeVC = HomeViewController()
    private var menuVC: MenuViewController!
    private var blackView = UIView()
    fileprivate var isExpanded = false
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            homeVC.user = user
            configureMenuVC(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureHomeVC()
        configureBlackView()
        checkIfUserIsLoggedIn()
    }
    
    @objc func dismissBlackView() {
        isExpanded = false
        animateMenu(shouldExpand: false)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let loginVC = LogInViewController()
            loginVC.containerVC = self
            
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            fetchUserData()
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LogInViewController())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.shared.fetchUserData(uid: uid) { [weak self] user in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    private func configureBlackView() {
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBlackView))
        blackView.addGestureRecognizer(tap)
    }
    
    func configureHomeVC() {
        addChild(homeVC)
        homeVC.didMove(toParent: self)
        view.addSubview(homeVC.view)
        homeVC.delegate = self
    }
    
    func configureMenuVC(withUser user: User) {
        menuVC = MenuViewController(user: user)
        menuVC.delegate = self
        addChild(menuVC)
        menuVC.didMove(toParent: self)
        view.insertSubview(menuVC.view, at: 0)
    }
    
    func animateMenu(shouldExpand: Bool, completion:  ((Bool) -> Void)? = nil) {
        if shouldExpand {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: {
                    self.homeVC.view.frame.origin.x = self.view.frame.width - 80
                    self.blackView.alpha = 1
                    self.blackView.frame = CGRect(x: self.view.frame.width-80, y: 0, width: 80,  height: self.view.frame.height)
                },
                completion: nil
            )
        } else {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: {
                    self.homeVC.view.frame.origin.x = 0
                    self.blackView.alpha = 0
                    self.blackView.frame = CGRect(x: 0, y: 0, width: 0,  height: self.view.frame.height)
                },
                completion: completion
            )
        }
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(option: MenuOptions) {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded) { _ in
            switch option {
            case .yourTrips:
                break
            case .settings:
                let settingsVC = SettingsViewController()
                    
                let nav = UINavigationController(rootViewController: settingsVC)
                self.present(nav, animated: true, completion: nil)
            case .logOut:
                let alert = UIAlertController(title: nil, message: "You are going to log out", preferredStyle: .actionSheet)
                
                let logout = UIAlertAction(title: "Log Out", style: .destructive) { _ in
                    self.signOut()}
                alert.addAction(logout)
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
