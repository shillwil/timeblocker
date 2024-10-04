//
//  ManualAddTimeBlockView.swift
//  TimeBlocker
//
//  Created by William Shillingford on 10/3/24.
//

import SwiftUI

struct ManualAddTimeBlockView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FocusState private var focusedField: Field?
    @State private var name: String = ""
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date())!
    
    enum Field {
        case textField
        case startTimePicker
        case endTimePicker
        case cancel
        case create
    }
    
    var body: some View {
        VStack() {
            nameTextField
            
            timePicker("Start Time", selection: $selectedStartTime)
                .focused($focusedField, equals: .startTimePicker)
            
            timePicker("End Time", selection: $selectedEndTime)
                .focused($focusedField, equals: .endTimePicker)
            
            Spacer()
            
            createButton()
        }
        .padding(.horizontal)
        .padding(.top, 64)
        .padding(.bottom)
        .navigationTitle($name.wrappedValue.isEmpty ? "Create Time Block" : $name.wrappedValue)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.red)
                }
                .focused($focusedField, equals: .cancel)
            }
        }
    }
    
    private var nameTextField: some View {
        VStack(alignment: .leading) {
            Text("What is this time block for?")
                .font(.title2)
                .bold()
            
            TextField("Data structures and algorithm study...", text: $name)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .textField ? Color.blue : Color.clear, lineWidth: 1)
                )
                .focused($focusedField, equals: .textField)
        }
    }
    
    private func timePicker(_ title: String, selection: Binding<Date>) -> some View {
        DatePicker(title, selection: selection, displayedComponents: .hourAndMinute)
    }
    
    private func createButton() -> some View {
        Button {
            createAndAddTimeBlock()
            dismiss()
        } label: {
            Text("Create")
                .font(.title2)
                .foregroundStyle(Color(uiColor: .white))
                .padding()
                .padding(.horizontal, 120)
                .background(Color.blue)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .focused($focusedField, equals: .create)
        }
    }
    
    private func createAndAddTimeBlock() {
        var newTimeBlock = TimeBlock(context: moc)
        newTimeBlock.name = name
        newTimeBlock.startTime = selectedStartTime
        newTimeBlock.endTime = selectedEndTime
        
        do {
            try moc.save()
        } catch let error {
            fatalError("Failed saving to Core Data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ManualAddTimeBlockView()
}
