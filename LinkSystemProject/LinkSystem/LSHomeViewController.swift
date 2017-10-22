//
//  LSHomeViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 02/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit


fileprivate let kPageHeadingHorizontalPadding:CGFloat = 27
fileprivate let kPageHeadingTopPadding:CGFloat = 31
fileprivate let kInterSectionVerticalPadding:CGFloat = 50

class LSHomeViewController: UIViewController {

    let pageHeadingLabel = UILabel()
    let sectionItems = ["Practice", "Statistics", "Licences"]
    var sectionLabels:[UIButton] = []
    var sectionBullets: [LSSquareBulletView] = []
    var panGesture:UIPanGestureRecognizer!
    let animator = TransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
        view.backgroundColor = UIColor.white
        createViews()
    }
    
    fileprivate func createViews() -> Void {
        createPageHeadingLabel()
        createSectionItemLabels()
        createSectionSquareBullets()
        
        NSLayoutConstraint.activate([
            pageHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kPageHeadingHorizontalPadding),
            pageHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kPageHeadingHorizontalPadding),
            pageHeadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: kStatusBarHeight + kPageHeadingTopPadding)
            ])
        
        for (i,label) in sectionLabels.enumerated() {
            let topPadding = i==0 ? CGFloat(66):kInterSectionVerticalPadding
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
        animateBullets()
    }
    
    fileprivate func animateBullets() {
        for bullet in sectionBullets {
            bullet.heightConstraint?.constant = LSSquareBulletView.squareSize
            bullet.widthConstraint?.constant = LSSquareBulletView.squareSize
        }
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
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
    
    
    @objc func goToLinkSettingsPage() {
        let vc = LSLinkStartViewController()
        vc.transitioningDelegate = self
        vc.animator = self.animator
        present(vc, animated: true, completion: nil)
    }
    
    @objc func goToStatisticsPage() {
        let statVC = LSStatisticsViewController()
        var statData = [(title:String,text:String)]()
        statData += [("Total number of links - \(NSString(format: "%d", LSHelpers.totalGameCount))", "This number represents the total number of links you've attempted to recall")]
        statData += [("Longest successful link length - \(LSHelpers.longestStreakCount)", "The longest link recalled with 100% completion ratio")]
        statVC.stats = statData
        statVC.animator = self.animator
        statVC.transitioningDelegate = self
        present(statVC, animated: true)
    }
    
    @objc func goToLicencesPage() {
        // TODO: Fix this later
    }
    
    @objc func handlePan(gesture:UIPanGestureRecognizer) {
        guard let superView = view.superview, abs(gesture.translation(in: superView).y) > 0 else {return}
        switch panGesture.state {
        case .began:
            goToLinkSettingsPage()
            animator.handlePan(gesture: gesture)
        default:
            animator.handlePan(gesture: gesture)
        }
    }
}

extension LSHomeViewController:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = true
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = false
        return self.animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator.isPresenting = true
        return self.animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator.isPresenting = false
        return self.animator
    }
}

