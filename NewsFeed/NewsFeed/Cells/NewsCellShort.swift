//
//  NewsCellOne.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 13.12.2023.
//

import UIKit

class NewsCellShort: BaseCell {
    
    static let cellID = "NewsCellShort"
    
    override func setNewsTitleLabel() {
        newsTitleLabel.textColor = .systemGray6
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.textAlignment = .left
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.font = .boldSystemFont(ofSize: 30)
        addSubview(newsTitleLabel)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            channelLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            channelLabel.heightAnchor.constraint(equalToConstant: 20),
            channelLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            channelLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            newsTitleLabel.topAnchor.constraint(equalTo: channelLabel.bottomAnchor),
            newsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            newsTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
