//
//  ShimmerAnimation.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/4/24.
//

import SwiftUI

struct ShimmerAnimation: ViewModifier {
    @State private var phase: CGFloat = -300

    func body(content: Content) -> some View {
        content
            .modifier(ShimmerViewModifier(phase: phase))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    self.phase = 300  // Animate to a value that covers the content sufficiently
                }
            }
    }
}
