//
//  Date+Extension.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 17.12.2023.
//

import Foundation

extension Date {
    
    func differenceDate() -> String {
        let calendar = Calendar.current
        let month = calendar.dateComponents([.month], from: self, to: .now).month
        let day = calendar.dateComponents([.day], from: self, to: .now).day
        let hour = calendar.dateComponents([.hour], from: self, to: .now).hour
        let minute = calendar.dateComponents([.minute], from: self, to: .now).minute
        
        if let month, month != 0 {
            return "\(month) month ago"
        } else if let day, day != 0 {
            return "\(day) day ago"
        } else if let hour, hour != 0 {
            return "\(hour) hours ago"
        } else if let minute {
            return "\(minute) minutes ago"
        }
        
        return ""
    }
    
    func toString(format: String = "HH:mm, dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

