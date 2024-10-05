//
//  TimeBlockerApp.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

@main
struct TimeBlockerApp: App {
    @StateObject private var dataManager = CoreDataManager()
    
    var body: some Scene {
        WindowGroup {
            TimeBlockListView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
