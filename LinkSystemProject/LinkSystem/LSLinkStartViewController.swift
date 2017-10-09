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
//        headingLabel.transform = CGAffineTransform(translationX: 0, y: 2*view.frame.height)
//        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseOut], animations: {
//            self.headingLabel.transform = .identity
//
//        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        createHeadingLabel()
        createItemCountTextField()
        
        view.addSubview(startLinkButton)
        startLinkButton.setTitle("Start", for: .normal)
        startLinkButton.translatesAutoresizingMaskIntoConstraints = false
        startLinkButton.titleLabel?.font = LSFonts.SectionHeadingMedium
        startLinkButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        startLinkButton.addTarget(self, action: #selector(startLink), for: .touchUpInside)
        
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
        
        
    }
    
    @objc func startLink() {
        dismiss(animated: true)
    }
    
}


extension LSLinkStartViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
