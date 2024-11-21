//
//  TimeBlockerApp.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI
import Supabase

@main
struct TimeBlockerApp: App {
    @StateObject private var dataManager = CoreDataManager()
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch authService.authState {
                case .undefined:
                    ProgressView()
                case .authenticated:
                    TimeBlockListView()
                        .environment(\.managedObjectContext, dataManager.container.viewContext)
                case .notAuthenticated:
                    LoginView()
                }
            }
        }
    }
}
