//
//  Date+Extension.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

extension Date {
    /**
     Generate string which means created date, such as 3d, 1h, 1y.
     - parameter createdUtc: Created UTC time as Int.
     - returns: String, means created date.
     */
    func createdDateDescription(createdUtc: Int) -> String {
        let d = Date(timeIntervalSince1970: Double(createdUtc))
        let diff = Int(Date().timeIntervalSince1970 - d.timeIntervalSince1970)
        if diff < 3600 {
            let minutes = diff / 60
            return "\(minutes) minutes ago"
        }
        if diff < 3600 * 24 {
            let hours = diff / 3600
            return "\(hours) hours ago"
        }
        if diff < 3600 * 24 * 31 {
            let days = diff / 3600 / 24
            return "\(days)d"
        }
        if diff < 3600 * 24 * 31 * 365 {
            let months = diff / 3600 / 24 / 31
            return "\(months) months ago"
        }
        let years = diff / 3600 / 365
        return "\(years)years ago"
    }
}
