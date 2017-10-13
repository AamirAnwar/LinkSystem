//
//  LSSquareBulletView.swift
//  LinkSystem
//
//  Created by Aamir  on 09/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation
import UIKit

class LSSquareBulletView:UIView {
    static let squareSize:CGFloat = 12
    var widthConstraint:NSLayoutConstraint?
    var heightConstraint:NSLayoutConstraint?
    class func square(withColor color:UIColor = LSColors.CustomBlack) -> LSSquareBulletView {
        let square = LSSquareBulletView(frame: CGRect(x: 0, y: 0, width: LSSquareBulletView.squareSize, height: LSSquareBulletView.squareSize))
        square.translatesAutoresizingMaskIntoConstraints = false
        square.backgroundColor = color
        return square
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            if let widthCon = self.widthConstraint, let heightCon = self.heightConstraint {
                NSLayoutConstraint.activate([widthCon,heightCon])
            }
            else {
                let widthCon = self.widthAnchor.constraint(equalToConstant: LSSquareBulletView.squareSize)
                let heightCon = self.heightAnchor.constraint(equalToConstant: LSSquareBulletView.squareSize)
                NSLayoutConstraint.activate([widthCon,heightCon])
                self.widthConstraint = widthCon
                self.heightConstraint = heightCon
            }
        }
    }
}
