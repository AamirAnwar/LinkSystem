//
//  LSStatsTableViewCell.swift
//  LinkSystem
//
//  Created by Aamir  on 12/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class LSStatsTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let square = LSSquareBulletView.square()
        contentView.addSubview(square)
        square.heightConstraint?.constant = LSSquareBulletView.squareSize
        square.widthConstraint?.constant = LSSquareBulletView.squareSize
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = LSFonts.ParagraphTitleMedium
        titleLabel.textColor = LSColors.CustomBlack
        titleLabel.numberOfLines = 0
        
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = LSFonts.ParagraphBodySmall
        subtitleLabel.textColor = LSColors.LightGrey
        subtitleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            square.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: kSidePadding),
            square.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: square.trailingAnchor, constant: kDefaultPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -kSidePadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kDefaultPadding),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: kDefaultPadding),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -kDefaultPadding)
            ])
    }

}
