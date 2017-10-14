//
//  TransitionAnimator.swift
//  LinkSystem
//
//  Created by Aamir  on 14/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation
import UIKit

class TransitionAnimator:UIPercentDrivenInteractiveTransition,UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    let animationDuration = 0.5
    
    //MARK: Transition Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVCSnapshot = fromVC.view.snapshotView(afterScreenUpdates: false)!
        
        fromVCSnapshot.frame = fromVC.view.frame
        transitionContext.containerView.addSubview(fromVCSnapshot)
        transitionContext.containerView.addSubview(toVC.view)
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.transform = CGAffineTransform(translationX: 0, y: toVC.view.frame.height)
        
        UIView.animate(withDuration: animationDuration, animations: {
            fromVCSnapshot.transform = CGAffineTransform(translationX: 0, y: -toVC.view.frame.height)
            fromVC.view.transform = CGAffineTransform(translationX: 0, y: -toVC.view.frame.height)
            toVC.view.transform = .identity
        }) { (_) in
            fromVCSnapshot.removeFromSuperview()
            fromVC.view.transform = .identity
            transitionContext.completeTransition(true)
        }
    }
    
    // MARK: Handle pan gesture
    func handlePan(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view!.superview!).y
        var progress:CGFloat = abs(translation/gesture.view!.frame.size.height)
        progress = min(max(progress,0.01), 0.99)
        print(progress)
        switch gesture.state {
        case .changed:
            update(progress)
            
        case .ended,.cancelled:
            finish()
        default:
            break
        }
    }
}
