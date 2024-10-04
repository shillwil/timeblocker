//
//  Extensions.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerAnimation())
    }
}
