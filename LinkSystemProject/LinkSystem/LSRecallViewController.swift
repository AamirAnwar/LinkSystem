//
//  LSRecallViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 11/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class LSRecallViewController: UIViewController {

    let textField = UITextField()
    let textFieldUnderline = UIView()
    let bubbleView = LSLinkBubbleView()
    var delegate:UITextFieldDelegate?
    var itemCount:Int = 10 {
        didSet {
            bubbleView.itemCount = itemCount
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = LSColors.CustomBlack
        textField.font = LSFonts.RecallFieldInput
        textField.textAlignment = .center
        textField.returnKeyType = .go
        textField.delegate = self.delegate
        
        textFieldUnderline.translatesAutoresizingMaskIntoConstraints = false
        textFieldUnderline.backgroundColor = LSColors.CustomBlack
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
//        bubbleView.backgroundColor = UIColor.red
        
        view.addSubview(bubbleView)
        view.addSubview(textField)
        view.addSubview(textFieldUnderline)
        
        
        NSLayoutConstraint.activate([
            
            bubbleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bubbleView.topAnchor.constraint(equalTo: view.topAnchor, constant:kStatusBarHeight),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:3*kSidePadding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-3*kSidePadding),
            textField.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant:kDefaultPadding*2),
            
            textFieldUnderline.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            textFieldUnderline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            textFieldUnderline.topAnchor.constraint(equalTo: textField.bottomAnchor, constant:5),
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        
        
        
    }
}
