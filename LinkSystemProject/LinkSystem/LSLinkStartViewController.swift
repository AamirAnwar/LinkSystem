//
//  LSLinkStartViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 09/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation
import UIKit

class LSLinkStartViewController:UIViewController {
    
    let headingLabel = UILabel()
    let itemCountTextField = UITextField()
    let textFieldUnderline = UIView()
    let startLinkButton = UIButton(type: .system)
    let startLinkChevronButton = UIButton(type: .system)
    let backChevronButton = UIButton(type: .system)
    
    fileprivate func createHeadingLabel() {
        view.addSubview(headingLabel)
        headingLabel.text = "Number of items"
        headingLabel.textAlignment = .center
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.textColor = LSColors.CustomBlack
        headingLabel.font = LSFonts.SectionHeadingMedium
    }
    
    fileprivate func createItemCountTextField() {
        view.addSubview(itemCountTextField)
        itemCountTextField.translatesAutoresizingMaskIntoConstraints = false
        itemCountTextField.backgroundColor = UIColor.clear
        itemCountTextField.tintColor = LSColors.CustomBlack
        itemCountTextField.textAlignment = .center
        itemCountTextField.delegate = self
        itemCountTextField.font = LSFonts.ParagraphTitleBig
        itemCountTextField.text = "10" // Default value
        itemCountTextField.textColor = LSColors.CustomBlack
        itemCountTextField.keyboardType = .numberPad
        
        textFieldUnderline.translatesAutoresizingMaskIntoConstraints = false
        textFieldUnderline.backgroundColor = LSColors.CustomBlack
        view.addSubview(textFieldUnderline)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if startLinkChevronButton.layer.animation(forKey: "hover") == nil {
            let anim = CABasicAnimation(keyPath: "position.y")
            anim.duration = 0.5
            anim.fromValue = startLinkChevronButton.layer.position.y
            anim.toValue = startLinkChevronButton.layer.position.y + 5
            anim.beginTime = CACurrentMediaTime() + 0.5
            anim.repeatCount = Float.infinity
            anim.autoreverses = true
            startLinkChevronButton.layer.add(anim, forKey: "hover")
        }
        backChevronButton.layer.cornerRadius = max(backChevronButton.frame.size.width, backChevronButton.frame.size.height)/2
//        headingLabel.transform = CGAffineTransform(translationX: 0, y: 2*view.frame.height)
//        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseOut], animations: {
//            self.headingLabel.transform = .identity
//
//        }, completion: nil)
    }
    
    fileprivate func createStartLinkButton() {
        view.addSubview(startLinkButton)
        startLinkButton.setTitle("Start", for: .normal)
        startLinkButton.translatesAutoresizingMaskIntoConstraints = false
        startLinkButton.titleLabel?.font = LSFonts.SectionHeadingMedium
        startLinkButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        startLinkButton.addTarget(self, action: #selector(startLink), for: .touchUpInside)
    }
    
    fileprivate func createStartLinkChevronButton() {
        view.addSubview(startLinkChevronButton)
        startLinkChevronButton.translatesAutoresizingMaskIntoConstraints = false
        startLinkChevronButton.setTitle(LSFontIcon.chevronDown, for: .normal)
        startLinkChevronButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        startLinkChevronButton.titleLabel?.font = LSFonts.iconFontWith(size: 24)
        startLinkChevronButton.addTarget(self, action: #selector(startLink), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        createHeadingLabel()
        createItemCountTextField()
        createStartLinkButton()
        createStartLinkChevronButton()
        
        view.addSubview(backChevronButton)
        backChevronButton.translatesAutoresizingMaskIntoConstraints = false
        backChevronButton.setTitle(LSFontIcon.chevronUp, for: .normal)
        backChevronButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        backChevronButton.backgroundColor = UIColor.clear
        backChevronButton.titleLabel?.font = LSFonts.iconFontWith(size: 22)
        backChevronButton.layer.borderColor = LSColors.LightGrey.cgColor
        backChevronButton.layer.borderWidth = 0.7
        backChevronButton.addTarget(self, action: #selector(backChevronTapped), for: .touchUpInside)
        
        let inset:CGFloat = 10
        backChevronButton.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        NSLayoutConstraint.activate([
            backChevronButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backChevronButton.topAnchor.constraint(equalTo: view.topAnchor, constant:kStatusBarHeight + 2*kDefaultPadding)
            ])
        
        
        NSLayoutConstraint.activate([
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kSidePadding),
            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kSidePadding),
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 135)
            ])
        
        NSLayoutConstraint.activate([
            itemCountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:view.frame.size.width/3),
            itemCountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-view.frame.size.width/3),
            itemCountTextField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant:30),
            textFieldUnderline.leadingAnchor.constraint(equalTo: itemCountTextField.leadingAnchor),
            textFieldUnderline.trailingAnchor.constraint(equalTo: itemCountTextField.trailingAnchor),
            textFieldUnderline.bottomAnchor.constraint(equalTo: itemCountTextField.bottomAnchor, constant:5),
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        NSLayoutConstraint.activate([
            startLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startLinkButton.topAnchor.constraint(equalTo: itemCountTextField.bottomAnchor, constant: 90)
            ])
        
        NSLayoutConstraint.activate([
            startLinkChevronButton.topAnchor.constraint(equalTo: startLinkButton.bottomAnchor, constant:kDefaultPadding),
            startLinkChevronButton.centerXAnchor.constraint(equalTo: startLinkButton.centerXAnchor),
            ])
    }
    
    @objc func backChevronTapped() {
        dismiss(animated: true)
    }
    
    @objc func startLink() {
        if let count = Int(itemCountTextField.text!) {
            let vc = LSLinkListViewController()
            vc.itemCount = count
            present(vc, animated: true)
        }
    }

}


extension LSLinkStartViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

