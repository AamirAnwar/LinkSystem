//
//  LSLinkCollectionViewCell.swift
//  LinkSystem
//
//  Created by Aamir  on 11/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class LSLinkCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = kCornerRadius
        contentView.layer.borderColor = LSColors.CustomBlack.cgColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = LSFonts.ParagraphTitleBig
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2*kDefaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: kSidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -kSidePadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2*kDefaultPadding)
            ])
    }
    
}
