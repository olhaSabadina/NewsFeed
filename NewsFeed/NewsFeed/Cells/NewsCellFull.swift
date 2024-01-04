//
//  NewsCellTwo.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 13.12.2023.
//
import SDWebImage
import UIKit

class NewsCellFull: BaseCell {
    
    static let cellID = "NewsCellFull"
    
    override func updateCell() {
        configureChannelName()
        
        guard let newsModel else { return }
        newsTitleLabel.text = newsModel.newsTitle
        
        guard let urlImage = URL(string: newsModel.imageUrl ?? "") else { return }
        newsImageView.sd_setImage(with: urlImage)
        
        bookmarkButton.setImage(newsModel.isFavourite ? ImageConstants.bookmarkFavourite : ImageConstants.bookmark, for: .normal)
    }
    
    override func setNewsImageView() {
        newsImageView.contentMode = .scaleAspectFit
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newsImageView)
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
            
            newsImageView.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 5),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            newsImageView.heightAnchor.constraint(equalToConstant: 200),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
