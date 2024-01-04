//
//  String+Extension.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 17.12.2023.
//

import Foundation

extension String {
    
    func firstThreewords() -> String {
        let words = self.components(separatedBy: " ")
        return words.prefix(4).joined(separator: " ")
    }
}
