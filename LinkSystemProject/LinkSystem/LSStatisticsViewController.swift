//
//  LSStatisticsViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 12/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
fileprivate let kStatCellReuseIdentifier = "StatCellIdentifier"

class LSStatisticsViewController: UIViewController {
    let pageHeadingLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    var linkItems:[String]? = nil
    var stats:[(title:String,text:String)] = []
    let backButton = UIButton(type: .system)
    let homeChevronButton = UIButton(type: .system)
    let repeatLinkButton = UIButton(type: .system)
    
    fileprivate func createHomeChevronButton() {
        view.addSubview(homeChevronButton)
        homeChevronButton.translatesAutoresizingMaskIntoConstraints = false
        homeChevronButton.setTitle(LSFontIcon.chevronDown, for: .normal)
        homeChevronButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        homeChevronButton.titleLabel?.font = LSFonts.iconFontWith(size: 24)
        homeChevronButton.addTarget(self, action: #selector(goHomeTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageHeadingLabel()
        createHomeChevronButton()
        
        view.addSubview(repeatLinkButton)
        repeatLinkButton.translatesAutoresizingMaskIntoConstraints = false
        repeatLinkButton.setTitle("Try again", for: .normal)
        repeatLinkButton.setTitleColor(UIColor.white, for: .normal)
        repeatLinkButton.backgroundColor = LSColors.CustomBlack
        repeatLinkButton.titleLabel?.font = LSFonts.NavigationActionTitle
        repeatLinkButton.addTarget(self, action: #selector(repeatLinkTapped), for: .touchUpInside)
        
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LSStatsTableViewCell.self, forCellReuseIdentifier: kStatCellReuseIdentifier)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Proceed", for: .normal)
        backButton.titleLabel?.font = LSFonts.SectionHeadingMedium
        backButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        backButton.addTarget(self, action: #selector(goHomeTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            pageHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kPageHeadingHorizontalPadding),
            pageHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kPageHeadingHorizontalPadding),
            pageHeadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: kStatusBarHeight + kPageHeadingTopPadding),
            tableView.topAnchor.constraint(equalTo: pageHeadingLabel.bottomAnchor, constant: 4*kDefaultPadding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kSidePadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kSidePadding),
            tableView.bottomAnchor.constraint(equalTo: repeatLinkButton.topAnchor, constant:-3*kDefaultPadding),
            
            repeatLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatLinkButton.widthAnchor.constraint(equalToConstant: 125),
            repeatLinkButton.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.topAnchor.constraint(equalTo: repeatLinkButton.bottomAnchor, constant: 40),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: homeChevronButton.topAnchor, constant:kDefaultPadding),
            
            homeChevronButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeChevronButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-3*kDefaultPadding),
            
            
            ])
    }
    
    

    func createPageHeadingLabel() {
        pageHeadingLabel.numberOfLines = 1
        view.addSubview(pageHeadingLabel)
        pageHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        pageHeadingLabel.font = LSFonts.PageHeading
        pageHeadingLabel.text = "Statistics"
        pageHeadingLabel.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @objc func goHomeTapped() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = LSHomeViewController()
        }
    }
    
    @objc func repeatLinkTapped() {
        if let linkItems = linkItems {
            let vc = LSLinkListViewController()
            vc.linkItems = linkItems
            present(vc, animated: true)
        }
    }
    

}

extension LSStatisticsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kStatCellReuseIdentifier) as! LSStatsTableViewCell
        cell.titleLabel.text = stats[indexPath.row].title
        cell.subtitleLabel.text = stats[indexPath.row].text
        return cell
    }
}

