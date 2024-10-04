//
//  ContentView.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var timeblocks: FetchedResults<TimeBlock>
    var body: some View {
        NavigationStack {
            List {
                ForEach(timeblocks, id: \.name) { timeblock in
                    let backgroundColor = timeblockHasEnded(timeblock.endTime) ? Color.gray : Color(uiColor: .systemFill)
                    Section {
                        TimeBlockCell(timeBlock: timeblock)
                            .listRowBackground(backgroundColor)
                    }
                    .listRowInsets(EdgeInsets())

                }
                .onDelete(perform: deleteCell)
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ManualAddTimeBlockView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func deleteCell(at offsets: IndexSet) {
        for index in offsets {
            let timeblock = timeblocks[index]
            moc.delete(timeblock)
        }
        
        do {
            try moc.save()
        } catch let error {
            fatalError("Error saving on delete of timeblock: \(error.localizedDescription)")
        }
    }
    
    func timeblockHasEnded(_ endTime: Date?) -> Bool {
        if let endTime, endTime < Date() {
            return true
        }
        
        return false
    }
}

#Preview {
    ContentView()
}
