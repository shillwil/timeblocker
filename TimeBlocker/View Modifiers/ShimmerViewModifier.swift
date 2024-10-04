//
//  ShimmerViewModifier.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct ShimmerViewModifier: AnimatableModifier {
    var phase: CGFloat

    // This tells SwiftUI which property to animate
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func body(content: Content) -> some View {
        // Use a sufficiently large size for the gradient to cover the content
        let gradient = LinearGradient(
            gradient: Gradient(colors: [.clear, .clear, Color.white.opacity(0.4), .clear, .clear]),
            startPoint: .leading,
            endPoint: .trailing
        )

        return content
            .overlay(
                gradient
                    .rotationEffect(.degrees(180))
                    .offset(x: phase)
                    .blendMode(.lighten)
            )
            .mask(content)
    }
}
