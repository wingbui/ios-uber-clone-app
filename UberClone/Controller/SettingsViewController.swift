//
//  SettingsViewController.swift
//  UberClone
//
//  Created by wingswift on 14/11/2021.
//

import UIKit

class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureNavigationBar()
    }
    
    @objc func dismissSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(dismissSettings))
        
        navigationController?.navigationBar.backgroundColor = .backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.barStyle = .black
    }
}
