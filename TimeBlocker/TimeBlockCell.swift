//
//  TimeBlockCell.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct TimeBlockCell: View {
    var timeBlock: TimeBlock
    
    let totalWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                let progressWidth = totalWidth * CGFloat(calculateProgress())
                
                if let endTime = timeBlock.endTime, Date() < endTime {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: progressWidth, height: 100)
                        .shimmer()
                }
                
                VStack {
                    HStack {
                        VStack {
                            timeBlockName
                                .padding(.leading)
                                .padding(.top, 12)
                            
                            timeBlockTime
                                .padding(.leading)
                            
                            Spacer()
                            
                            timeBlockDuration
                                .padding(.leading)
                                .padding(.bottom, 12)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .frame(height: 100)
    }
    
    private var timeBlockName: some View {
        HStack {
            Text(timeBlock.name ?? "(Couldn't fetch name)")
                .foregroundStyle(labelColor())
                .bold()
            Spacer()
        }
    }
    
    private var timeBlockTime: some View {
        HStack {
            Text(timeRangeString(startTime: timeBlock.startTime, endTime: timeBlock.endTime))
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            Spacer()
        }
    }
    
    private var timeBlockDuration: some View {
        HStack {
            Text(durationString(startTime: timeBlock.startTime, endTime: timeBlock.endTime))
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            Spacer()
        }
    }
    
    func durationString(startTime: Date?, endTime: Date?) -> String {
        guard let startTime, let endTime else { return "(Error fetching duration)" }
        let timeInterval = endTime.timeIntervalSince(startTime)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        
        return formatter.string(from: timeInterval) ?? "(Error converting duration)"
    }
    
    func timeRangeString(startTime: Date?, endTime: Date?) -> String {
        guard let startTime, let endTime else { return "(Error fetching time range)"}
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        let start = formatter.string(from: startTime)
        let end = formatter.string(from: endTime)
        
        return "\(start)-\(end)"
    }
    
    func calculateProgress() -> Double {
        guard let startTime = timeBlock.startTime, let endTime = timeBlock.endTime else { return 0.0 }
        let totalTime = endTime.timeIntervalSince(startTime)
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        return max(0, min(1, elapsedTime / totalTime))
    }
    
    func labelColor() -> Color {
        if let endTime = timeBlock.endTime, endTime < Date() {
            return Color(uiColor: .darkGray)
        }
        
        return Color(uiColor: .label)
    }
}

#Preview {
    TimeBlockCell(timeBlock: timeblockTemplate)
}

let timeblockTemplate = TimeBlock()
