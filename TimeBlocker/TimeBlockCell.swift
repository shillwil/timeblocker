//
//  TimeBlockCell.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct TimeBlockCell: View {
    var body: some View {
        VStack {
            ZStack {
                Color(uiColor: UIColor.systemFill)
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Text("Data Structures and Algorithms")
                                    .bold()
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.top, 12)
                            HStack {
                                Text("8:00am-10:00am")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                                Spacer()
                            }
                            .padding(.leading)
                            Spacer()
                            HStack {
                                Text("2 Hours")
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
        .padding()
    }
}

#Preview {
    TimeBlockCell()
}
