//
//  SearchCell.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 28.12.2023.
//

import UIKit

class SmallNewsCell: BaseCell {
    
    static let cellID = "searchCell"
    
    let lineViewBottom = UIView()
    
    override func setLineView() {
        lineViewBottom.backgroundColor = .systemGray6
        lineViewBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineViewBottom.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineViewBottom)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            channelLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            channelLabel.heightAnchor.constraint(equalToConstant: 30),
            channelLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            channelLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            
            bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 28),
            bookmarkButton.widthAnchor.constraint(equalTo: bookmarkButton.heightAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            newsTitleLabel.topAnchor.constraint(equalTo: channelLabel.bottomAnchor),
            newsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            newsTitleLabel.bottomAnchor.constraint(equalTo: lineViewBottom.topAnchor, constant: -15),
            
            lineViewBottom.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineViewBottom.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineViewBottom.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
