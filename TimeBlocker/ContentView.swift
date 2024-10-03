//
//  ContentView.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .navigationTitle("Today")
        }
    }
}

#Preview {
    ContentView()
}
