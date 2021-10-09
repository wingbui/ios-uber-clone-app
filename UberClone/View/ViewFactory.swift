//
//  ViewFactory.swift
//  UberClone
//
//  Created by wingswift on 18/09/2021.
//

import UIKit

class ViewFactory {
    
    static func createLinkButton(normalText: String, linkText: String) -> UIButton {
        let btn = UIButton(type: .system)
        let attributedText =
            NSMutableAttributedString(
                string: normalText,
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        attributedText.append(
            NSAttributedString(
                string: linkText,
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                    NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
            )
        )
        
        btn.setAttributedTitle(attributedText, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }
    
    
    static func createPrimaryButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.mainBlue
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return btn
    }
    
    
    static func makeLogo() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        
        return label
    }
    
    
    static func createSegmentedControl() -> UISegmentedControl {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return sc
    }
    
    
    static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    static func createPointView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 6 / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    
    static func createTextField() -> UITextField {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    
    static func createIconButton(iconName: String, color: UIColor = .black) -> UIButton {
        let image = UIImage(systemName: iconName)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(color)
        
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    
    static func createSeparatorView() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        return separator
    }
}
