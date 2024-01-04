//
//  newsModel.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 14.12.2023.
//

import UIKit

struct RSSModel {
    
    let channelName: String
    let timePosts: Date
    let newsTitle: String
    let newsDescription: String?
    let newsImage: String?
    let urlLink: String
    let typeCell: Int
    
    init(channelName: String, timeAppearance: Date, newsTitle: String, newsShortDescription: String? = nil, image: String? = nil, urlLink: String, typeCell: Int ) {
        self.channelName = channelName
        self.timePosts = timeAppearance
        self.newsTitle = newsTitle
        self.newsDescription = newsShortDescription
        self.newsImage = image
        self.urlLink = urlLink
        self.typeCell = typeCell
    }
}


