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
    var sectionBullets: [LSSquareBulletView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        createPageHeadingLabel()
        createSectionItemLabels()
        createSectionSquareBullets()
        
        NSLayoutConstraint.activate([
            pageHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kPageHeadingHorizontalPadding),
            pageHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kPageHeadingHorizontalPadding),
            pageHeadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: kStatusBarHeight + kPageHeadingTopPadding)
            ])
        
        for (i,label) in sectionLabels.enumerated() {
            let topPadding = i==0 ? CGFloat(66):kInterItemPadding
            let topAncestor:UIView = i==0 ? pageHeadingLabel:sectionLabels[i - 1]
            let bullet = sectionBullets[i]
            bullet.heightConstraint?.constant = 0
            bullet.widthConstraint?.constant = 0
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAncestor.bottomAnchor, constant: topPadding),
                label.trailingAnchor.constraint(lessThanOrEqualTo: pageHeadingLabel.trailingAnchor),
                bullet.leadingAnchor.constraint(equalTo: pageHeadingLabel.leadingAnchor),
                bullet.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                bullet.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -20),
                ])
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for bullet in sectionBullets {
            bullet.heightConstraint?.constant = LSSquareBulletView.squareSize
            bullet.widthConstraint?.constant = LSSquareBulletView.squareSize
        }
        
        UIView.animate(withDuration: 1, delay: 1.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func createPageHeadingLabel() {
        pageHeadingLabel.numberOfLines = 1
        view.addSubview(pageHeadingLabel)
        pageHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        pageHeadingLabel.font = LSFonts.PageHeading
        pageHeadingLabel.text = "Link System"
        pageHeadingLabel.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    func createSectionItemLabels() {
        for i in 0..<sectionItems.count {
            let button = UIButton(type: .system)
            sectionLabels.append(button)
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = LSFonts.SectionHeadingBig
            button.setTitle(sectionItems[i], for: .normal)
            button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
            switch i {
            case 0:
                button.addTarget(self, action: #selector(goToLinkSettingsPage), for: .touchUpInside)
            case 1:
                button.addTarget(self, action: #selector(goToStatisticsPage), for: .touchUpInside)
            case 2:
                button.addTarget(self, action: #selector(goToLicencesPage), for: .touchUpInside)
            default:
                break
            }
        }
    }
    
    func createSectionSquareBullets() {
        for _ in sectionItems {
            let square = LSSquareBulletView.square()
            view.addSubview(square)
            sectionBullets += [square]
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageHeadingLabel.sizeToFit()
    }
    
    @objc func goToLinkSettingsPage() {
        present(LSLinkStartViewController(), animated: true, completion: nil)
    }
    
    @objc func goToStatisticsPage() {
        
    }
    
    @objc func goToLicencesPage() {
        
    }
    
    
    



}

