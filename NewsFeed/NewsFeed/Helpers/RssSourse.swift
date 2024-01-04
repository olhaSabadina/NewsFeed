//
//  RssSourse.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 17.12.2023.
//

import Foundation

enum RssSourse: CaseIterable {
    case ycombinator
    case aljazeera
    case foxnews
}

extension RssSourse {
    var urlString: String {
        switch self {
        case .ycombinator:
            return "https://news.ycombinator.com/rss"
        case .aljazeera:
            return "https://www.aljazeera.com/xml/rss/all.xml"
        case .foxnews:
            return "https://moxie.foxnews.com/google-publisher/latest.xml"
        }
    }
    
    var link: String {
        switch self {
        case .ycombinator:
            return "https://news.ycombinator.com/"
        case .aljazeera:
            return "https://www.aljazeera.com"
        case .foxnews:
            return "https://www.foxnews.com/"
        }
    }
    
   static var arraysURL: [String] {
        var result = [String]()
        RssSourse.allCases.forEach{result.append( $0.urlString)}
        return result
    }
}
