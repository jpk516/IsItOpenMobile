//
//  HotView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI
import UIKit
struct MyViewController: View {
    @State private var venues: [Venue] = []
    
    var body: some View {
        VStack {
            Text("All venues")
            
            List(venues, id:\.id) {venue in
                Text(venue.name)
            }
            .onAppear {
                // Call the APIManager to fetch data
                APIManager.fetchDataFromAPI { venues in
                    // Handle the data received from the API call
                    self.venues = venues
                    // Example: Print the names of venues
                    for venue in venues {
                        print(venue)
                    }
                    
                    // Example: Update UI elements with the retrieved data
                    DispatchQueue.main.async {
                        // Update UI elements
                    }
                }
            }
        }
    }
}

//struct HotView: View {
//    var body: some View {
//        Text("Hotbit")
//            .navigationTitle("Hot")
//        
//        UIViewControllerRepresentation { _ in
//                    MyViewController()
//                }
//            }
//        }

struct UIViewControllerRepresentation<Content: View>: UIViewControllerRepresentable {
    let content: (UIViewController) -> Content
    
    init(@ViewBuilder content: @escaping (UIViewController) -> Content) {
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let childView = content(uiViewController)
        let hostingController = UIHostingController(rootView: childView)
        uiViewController.addChild(hostingController)
        uiViewController.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: uiViewController.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: uiViewController.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: uiViewController.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: uiViewController.view.bottomAnchor)
        ])
        hostingController.didMove(toParent: uiViewController)
    }
}

//        NavigationView {
//            List(restaurants) { restaurant in
//                HStack {
//                    Image(systemName: restaurant.isOpen ? "circle.fill" : "circle")
//                        .foregroundColor(restaurant.isOpen ? .green : .red)
//                    // In ContentView, adjust the button action to set the selectedRestaurant
//                    Button(restaurant.name) {
//                        self.selectedRestaurant = restaurant
//                    }
//
//                    // Use .sheet(item:) for presenting the detail view
//                    .sheet(item: $selectedRestaurant) { restaurant in
//                        RestaurantDetailView(restaurant: restaurant, showingDetail: .constant(true))
//                    }
//                }
//            }
//            .navigationTitle("Is it Open?")
//            .sheet(isPresented: $showingDetail) {
//                if let restaurant = selectedRestaurant {
//                    // Assuming RestaurantDetailView is another view in your project
//                    RestaurantDetailView(restaurant: restaurant, showingDetail: $showingDetail)
//                        .onDisappear {
//                            // Present the form sheet after the detail view is dismissed
//                            self.showingFormSheet = true
//                        }
//                }
//            }
//            .sheet(isPresented: $showingFormSheet) {
//                Form {
//                    Section(header: Text("What's Up? Are they still serving?")) {
//                        Picker("Is it open?", selection: $isOpen) {
//                            Text("Yes! It's open!").tag("Open")
//                            Text("Nope. They're Closed.").tag("Closed")
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                    }
//
//                    Section(header: Text("What's it like?")) {
//                        ForEach(atmosphereOptions, id: \.self) { option in
//                            MultipleSelectionRow(title: option, isSelected: atmosphereTags.contains(option)) {
//                                if atmosphereTags.contains(option) {
//                                    atmosphereTags.remove(option)
//                                } else {
//                                    atmosphereTags.insert(option)
//                                }
//                            }
//                        }
//                    }
//
//                    Section {
//                        TextField("Any other details?", text: $otherDetails)
//                    }
//
//                    Section {
//                        Button("Check In") {
//                            // Handle the check-in action here
//                            print("Checked In with: isOpen=\(isOpen), tags=\(atmosphereTags), otherDetails=\(otherDetails)")
//                            // Dismiss the form sheet
//                            showingFormSheet = false
//                        }
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.red)
//                        .cornerRadius(8)
//                    }
//                }
//            }
//        }
