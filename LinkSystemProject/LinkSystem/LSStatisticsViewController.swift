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
    var panGesture:UIPanGestureRecognizer!
    var animator:TransitionAnimator? = nil
    
    fileprivate func createHomeChevronButton() {
        view.addSubview(homeChevronButton)
        homeChevronButton.translatesAutoresizingMaskIntoConstraints = false
        if linkItems != nil {
            homeChevronButton.setTitle(LSFontIcon.chevronDown, for: .normal)
        }
        else {
            homeChevronButton.setTitle(LSFontIcon.chevronUp, for: .normal)
        }
        homeChevronButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        homeChevronButton.titleLabel?.font = LSFonts.iconFontWith(size: 24)
        homeChevronButton.addTarget(self, action: #selector(goHomeTapped), for: .touchUpInside)
    }
    
    fileprivate func createRepeatLinkButton() {
        view.addSubview(repeatLinkButton)
        repeatLinkButton.translatesAutoresizingMaskIntoConstraints = false
        repeatLinkButton.setTitle("Try again", for: .normal)
        repeatLinkButton.setTitleColor(UIColor.white, for: .normal)
        repeatLinkButton.backgroundColor = LSColors.CustomBlack
        repeatLinkButton.titleLabel?.font = LSFonts.NavigationActionTitle
        repeatLinkButton.addTarget(self, action: #selector(repeatLinkTapped), for: .touchUpInside)
    }
    
    fileprivate func createBackButton() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Proceed", for: .normal)
        backButton.titleLabel?.font = LSFonts.SectionHeadingMedium
        backButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        backButton.addTarget(self, action: #selector(goHomeTapped), for: .touchUpInside)
    }
    
    fileprivate func createTableView() {
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LSStatsTableViewCell.self, forCellReuseIdentifier: kStatCellReuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
        
        createPageHeadingLabel()
        createHomeChevronButton()
        createRepeatLinkButton()
        createTableView()
        createBackButton()
        
        
        if linkItems == nil {
            backButton.isHidden = true
            repeatLinkButton.isHidden = true

            NSLayoutConstraint.activate([
                homeChevronButton.topAnchor.constraint(equalTo: view.topAnchor, constant: kStatusBarHeight + 20),
                homeChevronButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                pageHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kPageHeadingHorizontalPadding),
                pageHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kPageHeadingHorizontalPadding),
                pageHeadingLabel.topAnchor.constraint(equalTo: homeChevronButton.bottomAnchor, constant: kPageHeadingTopPadding),
                
                tableView.topAnchor.constraint(equalTo: pageHeadingLabel.bottomAnchor, constant: 2*kDefaultPadding),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kSidePadding),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kSidePadding),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                ])
            
        }
        else {
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
        
        guard linkItems != nil else {
            dismiss(animated: true)
            return
        }
        let vc = LSHomeViewController()
        vc.transitioningDelegate = self
        present(vc, animated: true)
    }
    
    @objc func repeatLinkTapped() {
        if let linkItems = linkItems {
            let vc = LSLinkListViewController()
            vc.linkItems = linkItems
            vc.transitioningDelegate = self
            present(vc, animated: true)
        }
    }
    
    @objc func handlePan(gesture:UIPanGestureRecognizer) {
        guard let superView = view.superview, abs(gesture.translation(in: superView).y) > 0 else {return}
        switch panGesture.state {
        case .began:
            goHomeTapped()
            self.animator?.handlePan(gesture: gesture)
        default:
            self.animator?.handlePan(gesture: gesture)
        }
    }
}

extension LSStatisticsViewController:UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator?.isPresenting = true
        return self.animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator?.isPresenting = true
        return self.animator
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

