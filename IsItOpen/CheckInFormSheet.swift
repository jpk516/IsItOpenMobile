//
//  CheckInFormSheet.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI

struct CheckInFormSheet: View {
    @Binding var showingFormSheet: Bool
    
    // State for form inputs
    @State private var isOpen: String = ""
    @State private var atmosphereTags: Set<String> = []
    @State private var otherDetails: String = ""
    
    let atmosphereOptions = ["Closing Up", "Open Late", "Upscale", "Budget Friendly", "Rowdy", "Laid Back", "Loud"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("What's Up? Are they still serving?")) {
                    Picker("Is it open?", selection: $isOpen) {
                        Text("Yes! It's open!").tag("Open")
                        Text("Nope. They're Closed.").tag("Closed")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("What's it like?")) {
                    ForEach(atmosphereOptions, id: \.self) { option in
                        MultipleSelectionRow(title: option, isSelected: atmosphereTags.contains(option)) {
                            if atmosphereTags.contains(option) {
                                atmosphereTags.remove(option)
                            } else {
                                atmosphereTags.insert(option)
                            }
                        }
                    }
                }
                
                Section {
                    TextField("Any other details?", text: $otherDetails)
                }
                
                Section {
                    Button("Check In") {
                        // Handle the check-in action here, such as updating a model or calling an API
                        
                        // Dismiss the form sheet
                        showingFormSheet = false
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.red)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Check In")
            .navigationBarItems(trailing: Button("Back") {
                showingFormSheet = false
            })
        }
    }
}
/*
/// A view for multiple selection rows
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundColor(.black)
    }
}
*/
