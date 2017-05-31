//
//  Utils.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 31.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import Foundation

class Utils {
    
  open class func dateFormatted(date: Date) -> String {
        var result: String = ""
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(), to: date)
        
        var year = 0
        var month = 0
        var day = 0
        var hour = 0
        var minute = 0
        
        if let yearT = interval.year {
            year = yearT
        }
        if let monthT = interval.month {
            month = monthT
        }
        if let dayT = interval.day {
            day = dayT
        }
        if let hourT = interval.hour {
            hour = hourT
        }
        if let minuteT = interval.minute {
            minute = minuteT
        }
    
        
        if year > 0 {
            result = (year == 1) ? "1 year ago" : "\(year) years ago"
        } else if month > 0 {
            result = (month == 1) ? "1 month ago" : "\(month) month ago"
        } else if day > 0 {
            result = (day == 1) ? "1 day ago" : "\(day) days ago"
        } else if hour > 0 {
            result = (hour == 1) ? "1 hour ago" : "\(hour) hours ago"
        } else if minute > 0 {
            result = (minute == 1) ? "1 minute ago" : "\(minute) minutes ago"
        }  else {
            result = "less than an hour ago"
    }
    
        return result
    }
    
    
    
    
    

}
