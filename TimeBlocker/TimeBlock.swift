//
//  TimeBlock.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import Foundation

struct TimeBlock {
    var name: String
    var startTime: Date
    var endTime: Date
    
    func durationString() -> String? {
        let timeInterval = endTime.timeIntervalSince(startTime)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        
        return formatter.string(from: timeInterval)
    }
    
    func timeRangeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        let start = formatter.string(from: startTime)
        let end = formatter.string(from: endTime)
        
        return "\(start)-\(end)"
    }
}
