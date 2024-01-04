//
//  NewsCellThree.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 13.12.2023.
//
import SDWebImage
import UIKit

class NewsCellMedium: BaseCell {
    
    static let cellID = "NewsCellMedium"
    
    override func setDescription() {
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .systemGray6
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
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
            
            descriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
