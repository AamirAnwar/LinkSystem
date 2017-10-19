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
    var isPresenting = false
    weak var storedContext:UIViewControllerContextTransitioning?
    
    //MARK: Transition Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        storedContext = transitionContext
        toView.transform = .identity
        toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: toView)
        let direction:CGFloat = isPresenting ? 1 : -1
        
        toView.transform = CGAffineTransform(translationX: 0, y: direction*toView.frame.height)
        
        UIView.animate(withDuration: animationDuration, animations: {
            toView.transform = .identity
            fromView.transform = CGAffineTransform(translationX: 0, y: direction*(-fromView.frame.height))
        }) { (_) in
            fromView.transform = .identity
            if transitionContext.transitionWasCancelled {
                toView.removeFromSuperview()
            }
            else {
                toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            }
//            transitionContext.transitionWasCancelled ? print("Closing transition because it was cancelled") : print("Finishing transition normally")
//            if transitionContext.transitionWasCancelled {
//                fromView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
//            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            self.storedContext = nil
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if let context = self.storedContext {
            if context.transitionWasCancelled {
//                print("From view at the end of a cancelled animation\(context.view(forKey: .from))")
//                print("To view at the end of a cancelled animation\(context.view(forKey: .to))")
                self.storedContext = nil
                
            }
        }
    }
    
    // MARK: Handle pan gesture
    func handlePan(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view!.superview!).y
        var progress:CGFloat = abs(translation/gesture.view!.frame.size.height)
        progress = min(max(progress,0.01), 0.99)
        let isPullingUp = translation < 0
        
        
        guard isPresenting == isPullingUp else {
            cancel()
            return
            
        }
        switch gesture.state {
            
        case .began:
            update(0.01)
        case .changed:
            update(progress)
            
        case .ended,.cancelled:
            (progress > 0.2) ? finish() : cancel()
        default:
            break
        }
    }
}
