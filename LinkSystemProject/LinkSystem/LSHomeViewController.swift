//
//  LSHomeViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 02/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
let kStatusBarHeight:CGFloat = 20
let kPageHeadingHorizontalPadding:CGFloat = 27
let kPageHeadingTopPadding:CGFloat = 31
let kInterItemPadding:CGFloat = 50
class LSHomeViewController: UIViewController {

    let pageHeadingLabel = UILabel()
    let sectionItems = ["Practice", "Statistics", "Licences"]
    var sectionLabels:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageHeadingLabel()
        createSectionItemLabels()
        
        NSLayoutConstraint.activate([
            pageHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kPageHeadingHorizontalPadding),
            pageHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kPageHeadingHorizontalPadding),
            pageHeadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: kStatusBarHeight + kPageHeadingTopPadding)
            ])
        
        for (i,label) in sectionLabels.enumerated() {
            let topPadding = i==0 ? CGFloat(66):kInterItemPadding
            let topAncestor:UIView = i==0 ? pageHeadingLabel:sectionLabels[i - 1]
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAncestor.bottomAnchor, constant: topPadding),
                label.leadingAnchor.constraint(equalTo: pageHeadingLabel.leadingAnchor)
                //label.trailingAnchor.constraint(equalTo: pageHeadingLabel.trailingAnchor),
                ])
            
        }
    }
    
    func createPageHeadingLabel() {
        pageHeadingLabel.numberOfLines = 1
        view.addSubview(pageHeadingLabel)
        pageHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        pageHeadingLabel.font = LSFontPageHeading
        pageHeadingLabel.text = "Link System"
        pageHeadingLabel.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    func createSectionItemLabels() {
        for i in 0..<sectionItems.count {
            let button = UIButton(type: .system)
            sectionLabels.append(button)
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = LSFontSectionHeading
            button.setTitle(sectionItems[i], for: .normal)
            button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageHeadingLabel.sizeToFit()
    }
    
    
    
    



}

