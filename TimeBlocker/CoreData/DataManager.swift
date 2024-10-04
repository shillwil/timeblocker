//
//  DataManager.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//
import CoreData
import Foundation

class CoreDataManager: ObservableObject {
    let container = NSPersistentContainer(name: "TimeBlockDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error { print("Core Data failed to load: \(error.localizedDescription)") }
        }
    }
}
