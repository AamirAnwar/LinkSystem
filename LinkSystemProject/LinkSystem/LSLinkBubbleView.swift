//
//  LSLinkBubbleView.swift
//  LinkSystem
//
//  Created by Aamir  on 11/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

fileprivate let linkViewCustomSidePadding = 4*kSidePadding

enum LinkBubble:CGFloat {
    case LinkBubbleBig = 90.0
    case LinkBubbleRegular = 40.0
    static func getBubbleWith(size:LinkBubble) -> UIView {
        let bubble = UIView(frame: CGRect(x: 0, y: 0, width: size.rawValue, height: size.rawValue))
        bubble.backgroundColor = UIColor.white
        bubble.layer.borderColor = LSColors.CustomBlack.cgColor
        bubble.layer.borderWidth = 0.7
        bubble.layer.cornerRadius = size.rawValue/2
        return bubble
        
    }
}

class LSLinkBubbleView: UIView {

    var itemCount:Int = 10
    var currentItem:Int = 0
    let lineView = UIView()
    var bubbles:[UIView] = []
    var middleRegionPadding:CGFloat = 0
    var currentBubbleIndex:Int!
    var isTransitioning = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard bubbles.isEmpty else {return}
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLinkView)))
        lineView.frame = CGRect(x: frame.width/2, y: frame.height/2 - 0.5, width: frame.width/2, height: 1)
        lineView.backgroundColor = LSColors.CustomBlack
        addSubview(lineView)
        
        
        let (width,_) = (frame.size.width, frame.size.height)
        let x = width/2
        middleRegionPadding = (width - 2*LinkBubble.LinkBubbleRegular.rawValue - LinkBubble.LinkBubbleBig.rawValue - 2*linkViewCustomSidePadding)/2
        
        let currentBubble = LinkBubble.getBubbleWith(size: .LinkBubbleBig)
        currentBubble.frame.origin = CGPoint(x: x - currentBubble.frame.height/2, y: (frame.height - currentBubble.frame.height)/2)
        addSubview(currentBubble)
        
        let nextBubble = LinkBubble.getBubbleWith(size: .LinkBubbleRegular)
        nextBubble.frame = CGRect(x: currentBubble.frame.maxX + middleRegionPadding, y: frame.height/2 - nextBubble.frame.height/2, width: nextBubble.frame.width, height: nextBubble.frame.height)
        addSubview(nextBubble)
        
        let forthComingBubble = LinkBubble.getBubbleWith(size: .LinkBubbleRegular)
        forthComingBubble.frame = CGRect(x: frame.width, y: nextBubble.frame.minY, width: forthComingBubble.frame.width, height: forthComingBubble.frame.height)
        addSubview(forthComingBubble)
        
        for bubble in self.bubbles {
            bubble.removeFromSuperview()
        }
        self.bubbles = [currentBubble,nextBubble,forthComingBubble]
        currentBubbleIndex = 0
        currentItem = 0
    }
    
    func next() {
        guard currentItem < itemCount, isTransitioning == false else {return}
        isTransitioning = true
        if currentItem == 0 {
            UIView.animate(withDuration: 1, animations: {
                // First item is current item
                let currentBubble = self.bubbles.first!
                self.fillLeftPositionWith(bubble: currentBubble)
                let nextBubble = self.bubbles[1]
                self.fillCurrentPositionWith(bubble: nextBubble)
                let forthComingBubble = self.bubbles[2]
                self.fillRightPositionWith(bubble: forthComingBubble)
                
                self.bubbles = [currentBubble, nextBubble,forthComingBubble]
                
                self.lineView.frame = CGRect(x: currentBubble.frame.minX, y: self.frame.height/2 - 0.5, width: self.frame.width - linkViewCustomSidePadding, height: 1)
            }, completion: { _ in
                self.isTransitioning = false
            })
        }
        else if currentItem == itemCount - 3 {
            // Third last item is current item
            UIView.animate(withDuration: 0.8, animations: {
                self.lineView.frame = CGRect(x: 0, y: self.frame.height/2 - 0.5, width: self.frame.width - linkViewCustomSidePadding, height: 1)
            })
            let leftBubble = bubbles.first!
            let forthComingBubble = self.createForthComingBubble()
            self.bubbles[0] = forthComingBubble
            UIView.animate(withDuration: 1.0, animations: {
                leftBubble.frame.origin = CGPoint(x:-LinkBubble.LinkBubbleRegular.rawValue,y:leftBubble.frame.origin.y)
                self.fillRightPositionWith(bubble: self.bubbles.first!)
                self.fillCurrentPositionWith(bubble: self.bubbles.last!)
                self.fillLeftPositionWith(bubble: self.bubbles[1])
                
            }, completion: { (_) in
                self.isTransitioning = false
                leftBubble.removeFromSuperview()
                self.bubbles = [self.bubbles[1],self.bubbles.last!,self.bubbles.first!]
            })
            
        }
        else if currentItem == itemCount - 2 {
            let leftBubble = bubbles.first!
            // second last item is current item
            UIView.animate(withDuration: 0.8, animations: {
                self.lineView.frame = CGRect(x: 0, y: self.frame.height/2 - 0.5, width: self.frame.width/2, height: 1)
            })
            
            UIView.animate(withDuration: 1.0, animations: {
                leftBubble.frame.origin = CGPoint(x:-LinkBubble.LinkBubbleRegular.rawValue,y:leftBubble.frame.origin.y)
                self.fillCurrentPositionWith(bubble: self.bubbles.last!)
                self.fillLeftPositionWith(bubble: self.bubbles[1])
                
            }, completion: { (_) in
                self.isTransitioning = false
                leftBubble.removeFromSuperview()
                self.bubbles = [self.bubbles[1],self.bubbles.last!,self.bubbles.first!]
            })
            
        }
        else if currentItem == itemCount - 1 {
            // last item is current item
            // Magical celeberation here
            isTransitioning = false
        }
        else {
            // In between link
            let leftBubble = bubbles.first!
            UIView.animate(withDuration: 0.8, animations: {
                self.lineView.frame = CGRect(x: 0, y: self.frame.height/2 - 0.5, width: self.frame.width, height: 1)
            })
            
            let forthComingBubble = self.createForthComingBubble()
            self.bubbles[0] = forthComingBubble
            UIView.animate(withDuration: 1.0, animations: {
                leftBubble.frame.origin = CGPoint(x:-LinkBubble.LinkBubbleRegular.rawValue,y:leftBubble.frame.origin.y)
                self.fillRightPositionWith(bubble: self.bubbles.first!)
                self.fillCurrentPositionWith(bubble: self.bubbles.last!)
                self.fillLeftPositionWith(bubble: self.bubbles[1])
                
            }, completion: { (_) in
                self.isTransitioning = false
                leftBubble.removeFromSuperview()
                self.bubbles = [self.bubbles[1],self.bubbles.last!,self.bubbles.first!]
            })
        }
        
        currentItem += 1
    }
    
    func createForthComingBubble() -> UIView {
        let forthComingBubble = LinkBubble.getBubbleWith(size: .LinkBubbleRegular)
        forthComingBubble.frame = CGRect(x: self.frame.width + self.middleRegionPadding, y: self.frame.height/2 - forthComingBubble.frame.height/2, width: forthComingBubble.frame.width, height: forthComingBubble.frame.height)
        self.addSubview(forthComingBubble)
        return forthComingBubble
    }
    
    func fillCurrentPositionWith(bubble:UIView) {
        let size = LinkBubble.LinkBubbleBig.rawValue
        bubble.frame = CGRect(x: self.frame.midX - size/2,
                                  y: (frame.height - size)/2,
                                  width: size,
                                  height: size)
        
        bubble.backgroundColor = UIColor.white
        bubble.layer.cornerRadius = size/2
        
        
    }
    
    func fillLeftPositionWith(bubble:UIView) {
        let size = LinkBubble.LinkBubbleRegular.rawValue
        bubble.frame = CGRect(x: linkViewCustomSidePadding,
                              y: self.frame.height/2 - size/2,
                              width: size,
                              height: size)
        
        bubble.backgroundColor = LSColors.CustomBlack
        bubble.layer.cornerRadius = size/2
        
        
    }
    
    func fillRightPositionWith(bubble:UIView) {
        let size = LinkBubble.LinkBubbleRegular.rawValue
        bubble.frame = CGRect(x: self.frame.width - linkViewCustomSidePadding - size,
                              y: self.frame.height/2 - size/2,
                              width: size,
                              height: size)
        bubble.backgroundColor = UIColor.white
        bubble.layer.cornerRadius = size/2
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width:UIScreen.main.bounds.width,height:110)
    }
    
//    @objc func didTapLinkView() {
//        self.next()
//    }
    
}
