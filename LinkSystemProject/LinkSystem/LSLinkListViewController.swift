//
//  LSLinkListViewController.swift
//  LinkSystem
//
//  Created by Aamir  on 11/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

fileprivate let kCollectionViewReuseIdentifier = "LinkListCollectionViewCellIdentifier"
fileprivate let kLinkListItemHeight:CGFloat = 72
fileprivate let kCloseButtonSize:CGFloat = 25
class LSLinkListViewController: UIViewController {

    let instructionHeadingLabel = UILabel()
    let instructionLabel = UILabel()
    let closeButton = UIButton(type: .system)
    let rightNavButton = UIButton(type: .system)
    let linkListCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var linkItems:[String] = []
    var itemCount:Int = 4
    var panGesture:UIPanGestureRecognizer!
    var recallViewController:LSRecallViewController?
    var timer:Timer?
    var timeCount:Double = 0.0
    var answerTimestamps:[Double] = []
    lazy var allItems:[String] = {
        if let file = Bundle.main.path(forResource: "nounlist", ofType: "txt") {
            do {
                let contents = try String.init(contentsOfFile: file, encoding: String.Encoding.utf8)
                return contents.components(separatedBy: CharacterSet.newlines)
                
            } catch let error as NSError {
                print("Could not read nouns \(error.localizedDescription)")
            }
        }
        return [String]()
    }()
    var animator:TransitionAnimator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if linkItems.isEmpty {
            loadLinkItems(withCount: itemCount)
        }
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
        
        instructionHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        rightNavButton.translatesAutoresizingMaskIntoConstraints = false
        linkListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Collection view
        linkListCollectionView.dataSource = self
        linkListCollectionView.delegate = self
        linkListCollectionView.register(LSLinkCollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewReuseIdentifier)
        linkListCollectionView.backgroundColor = UIColor.white
        linkListCollectionView.contentInset = UIEdgeInsetsMake(0, 0, kDefaultPadding, 0)
        view.addSubview(linkListCollectionView)
        
        
        instructionHeadingLabel.text = "Instruction"
        instructionHeadingLabel.font = LSFonts.ParagraphTitleBig
        instructionHeadingLabel.textColor = LSColors.LightGrey
        view.addSubview(instructionHeadingLabel)
        
        instructionLabel.text = "Link each object to the next one using the link system method."
        view.addSubview(instructionLabel)
        instructionLabel.textColor = LSColors.LightGrey
        instructionLabel.font = LSFonts.ParagraphBody
        instructionLabel.numberOfLines = 0
        
        closeButton.titleLabel?.font = LSFonts.iconFontWith(size: 16)
        view.addSubview(closeButton)
        closeButton.setTitle(LSFontIcon.closeButtonRounded, for: .normal)
        closeButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        closeButton.backgroundColor = UIColor.white
        closeButton.layer.cornerRadius = kCloseButtonSize/2
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        
        rightNavButton.titleLabel?.font = LSFonts.NavigationActionTitle
        view.addSubview(rightNavButton)
        rightNavButton.setTitle("Proceed", for: .normal)
        rightNavButton.backgroundColor = UIColor.white
        rightNavButton.setTitleColor(LSColors.CustomBlack, for: .normal)
        rightNavButton.addTarget(self, action: #selector(rightNavButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kSidePadding),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: kStatusBarHeight + 2*kDefaultPadding),
            closeButton.widthAnchor.constraint(equalToConstant: kCloseButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: kCloseButtonSize),
            
            rightNavButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kSidePadding),
            rightNavButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            instructionHeadingLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 4*kDefaultPadding),
            instructionHeadingLabel.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            instructionHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-kSidePadding),
            
            instructionLabel.topAnchor.constraint(equalTo: instructionHeadingLabel.bottomAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: instructionHeadingLabel.leadingAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: instructionHeadingLabel.trailingAnchor),
            
            linkListCollectionView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 4*kDefaultPadding),
            linkListCollectionView.leadingAnchor.constraint(equalTo: instructionLabel.leadingAnchor),
            linkListCollectionView.trailingAnchor.constraint(equalTo: instructionLabel.trailingAnchor),
            linkListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        
    }
    
    func loadLinkItems(withCount count:Int) {
        linkItems.removeAll()
        guard itemCount > 0 else {return}
        while linkItems.count != itemCount {
            let randomIndex = Int(arc4random())%(allItems.count)
            let item = allItems[randomIndex]
            guard item.isEmpty == false else {continue}
            linkItems += [item]
        }
    }
    
    func goToStatsPage() {
        if let recallViewController = recallViewController {
            let statVC = LSStatisticsViewController()
            statVC.linkItems = self.linkItems
            var statData = [(title:String,text:String)]()
            statData += [("Item Recall Ratio - \(NSString(format: "%.2f",Double(recallViewController.bubbleView.currentItem)/Double(linkItems.count) * 100))%", "Item recall ratio is defined as the number of items successfully remembered divided by the total number of items")]
            
            statData += [("Total Time - \(NSString(format: "%.2f", timeCount)) seconds", "")]
            
            statData += [("Average time per item - \(NSString(format: "%.2f", getAverageTimePerItem())) seconds","Average time is the total time taken to recall each item  in the link chain divided by the total number of items")]
            statVC.stats = statData
            statVC.animator = self.animator
            statVC.transitioningDelegate = self
            present(statVC, animated: true)
        }
    }
    
    func getAverageTimePerItem() -> Double {
        var totalTime:Double = 0
        var totalItems:Int = 0
        for (i,time) in answerTimestamps.enumerated() {
            guard time > 0.0 else {continue}
            
            var previousTime:Double = 0
            if i > 0 {
                previousTime = answerTimestamps[i - 1]
            }
            totalItems += 1
            totalTime += time - previousTime
        }
        
        guard totalItems > 0 else {return 0.0}
        return totalTime/Double(totalItems)
    }
    
    @objc func rightNavButtonTapped() {
        guard recallViewController == nil else {
            goToStatsPage()
            if recallViewController!.bubbleView.currentItem == linkItems.count {
                LSHelpers.updateLongestLinkStreak(withSteak: linkItems.count)
            }
            return
        }
        LSHelpers.incrementGameCount()
        UIView.transition(with: rightNavButton, duration: 1.0, options: [.transitionCrossDissolve], animations: {
            self.rightNavButton.setTitle("Done", for: .normal)
        })
        let vc = LSRecallViewController()
        vc.delegate = self
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.itemCount = itemCount
        view.addSubview(vc.view)
        
        recallViewController = vc
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant:2*kDefaultPadding),
            vc.view.bottomAnchor.constraint(equalTo: linkListCollectionView.bottomAnchor),
            ])
        
        UIView.transition(with: instructionLabel, duration: 1.0, options: [.transitionCrossDissolve], animations: {
            self.instructionLabel.text = "Recall the words one by one by typing them below"
        })
        vc.view.alpha = 0.0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.linkListCollectionView.alpha = 0.0
            
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                vc.view.alpha = 1
            })
            
            self.linkListCollectionView.isHidden = true
        }
        
        // Start timer
        answerTimestamps = [Double](repeating: 0, count: itemCount)
        timeCount = 0.0
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        recallViewController?.textField.becomeFirstResponder()
        
    }
    
    @objc func timerCallback() {
        timeCount += 0.1
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func handlePan(gesture:UIPanGestureRecognizer) {
        guard let superView = view.superview, abs(gesture.translation(in: superView).y) > 0 else {return}
        switch panGesture.state {
        case .began:
            if gesture.translation(in: gesture.view!.superview).y < 0 {
                goToStatsPage()
            }
            else {
                closeButtonTapped()
            }
            
            self.animator?.handlePan(gesture: gesture)
        default:
            self.animator?.handlePan(gesture: gesture)
        }
    }

}

extension LSLinkListViewController:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator?.isPresenting = true
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator?.isPresenting = false
        return self.animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator?.isPresenting = true
        return self.animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        self.animator?.isPresenting = false
        return self.animator
    }
}

extension LSLinkListViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return linkItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewReuseIdentifier, for: indexPath) as! LSLinkCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.titleLabel.text = linkItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2*kSidePadding, height: kLinkListItemHeight)
    }
    
    
}

extension LSLinkListViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let currentItemIndex = recallViewController?.bubbleView.currentItem {
            guard currentItemIndex < linkItems.count else {return false}
            let item = linkItems[currentItemIndex]
            if textField.text?.caseInsensitiveCompare(item) == .orderedSame {
                print("Correct answer for \(item) at \(timeCount) seconds")
                answerTimestamps[currentItemIndex] = timeCount
                recallViewController?.bubbleView.next()
                UIView.transition(with: textField, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                    textField.text = ""
                })
            }
            
            if currentItemIndex == linkItems.count - 1 {
                self.timer?.invalidate()
                print("Total time taken \(timeCount)")
            }
        }
        return false
    }
}
