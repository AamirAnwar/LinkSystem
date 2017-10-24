//
//  LSRecallViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 11/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class LSRecallViewController: UIViewController {

    let countLabel = UILabel()
    let textField = UITextField()
    let textFieldUnderline = UIView()
    var delegate:UITextFieldDelegate?
    var currentItem = 0 {
        didSet {
            countLabel.text = "\(currentItem)/\(itemCount)"
        }
    }
    var itemCount:Int = 10 {
        didSet {
            countLabel.text = "0/\(itemCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textColor = LSColors.CustomBlack
        countLabel.font = LSFonts.ParagraphTitleBig
        countLabel.textAlignment = .center
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = LSColors.CustomBlack
        textField.font = LSFonts.RecallFieldInput
        textField.textAlignment = .center
        textField.returnKeyType = .go
        textField.delegate = self.delegate
        
        textFieldUnderline.translatesAutoresizingMaskIntoConstraints = false
        textFieldUnderline.backgroundColor = LSColors.CustomBlack
        
        view.addSubview(countLabel)
        view.addSubview(textField)
        view.addSubview(textFieldUnderline)
        
        NSLayoutConstraint.activate([
            
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:4),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:3*kSidePadding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-3*kSidePadding),
            textField.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant:kDefaultPadding*3),
            
            textFieldUnderline.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            textFieldUnderline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            textFieldUnderline.topAnchor.constraint(equalTo: textField.bottomAnchor, constant:5),
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
}
