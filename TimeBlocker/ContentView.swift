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
                    Section {
                        TimeBlockCell(timeBlock: timeblock)
                            .listRowBackground(Color(uiColor: .systemFill))
                    }
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
}

#Preview {
    ContentView()
}
