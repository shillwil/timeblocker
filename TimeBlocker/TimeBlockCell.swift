//
//  TimeBlockCell.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct TimeBlockCell: View {
    var timeBlock: TimeBlock
    var body: some View {
        VStack {
            ZStack {
                Color(uiColor: UIColor.systemFill)
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Text(timeBlock.name)
                                    .bold()
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.top, 12)
                            HStack {
                                Text(timeBlock.timeRangeString())
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                                Spacer()
                            }
                            .padding(.leading)
                            Spacer()
                            HStack {
                                Text(timeBlock.durationString()!)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.bottom, 12)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                            .padding(.trailing)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(height: 100)
    }
}

#Preview {
    TimeBlockCell(timeBlock: timeblockTemplate)
}

let timeblockTemplate = TimeBlock(
    name: "Reading",
    startTime: Date(),
    endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!
)
