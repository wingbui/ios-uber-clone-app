//
//  MenuViewController.swift
//  UberClone
//
//  Created by wingswift on 31/10/2021.
//

import UIKit

private let reusableIdentifier = "MenuCell"

enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    case yourTrips
    case settings
    case logOut
    
    var description: String {
        switch self {
        case .yourTrips: return "Your Trips"
        case .settings: return "Settings"
        case .logOut: return "Log out"
        }
    }
}

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(option: MenuOptions)
    
}

class MenuViewController: UITableViewController {
    let user: User
    weak var delegate: MenuViewControllerDelegate?

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width - 80, height: 180)
        let view = MenuHeader(user: user, frame: frame)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.tableHeaderView = menuHeader
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: (self.parent?.view.frame.width)! - 75),
            tableView.heightAnchor.constraint(equalToConstant: (self.parent?.view.frame.height)!),
        ])
    }
}

extension MenuViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath)
        guard let option = MenuOptions(rawValue: indexPath.row) else { return UITableViewCell()}
        cell.textLabel?.text = option.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else { return }
        delegate?.didSelect(option: option)
    }
}
