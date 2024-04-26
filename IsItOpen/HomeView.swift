//
//  HomeView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI
import CoreLocation
import MapKit
import UIKit

struct HomeView: View {
    @State private var showingDetail = false
    @State private var showingFormSheet = false
    @State private var selectedRestaurant: Restaurant?
    
    // State for form inputs
    @State private var isOpen: String = ""
    @State private var atmosphereTags: Set<String> = []
    @State private var otherDetails: String = ""
    @State private var venues: [Venue] = []
    
    let atmosphereOptions = ["Closing Up", "Open Late", "Upscale", "Budget Friendly", "Rowdy", "Laid Back", "Loud"]
    
    let restaurants = [
        Restaurant(name: "Harpo's", websiteURL: URL(string: "http://harposcomo.com")!, hours: "11AM - 11PM", location: CLLocationCoordinate2D(latitude: 38.95064794213455, longitude: -92.32681850984262), isOpen: true),
        Restaurant(name: "The Heidelberg", websiteURL: URL(string: "http://theheidelberg.com")!, hours: "10AM - 10PM", location: CLLocationCoordinate2D(latitude: 38.94702278652283, longitude: -92.32745927316932), isOpen: false),
        Restaurant(name: "Booches Billiard Hall", websiteURL: URL(string: "http://booches.com")!, hours: "11AM - 12AM", location: CLLocationCoordinate2D(latitude: 38.9517, longitude: -92.3286), isOpen: true),
        Restaurant(name: "Shakespeare’s Pizza", websiteURL: URL(string: "http://shakespeares.com")!, hours: "11AM - 10PM", location: CLLocationCoordinate2D(latitude: 38.9480, longitude: -92.3267), isOpen: true),
        Restaurant(name: "Addison’s", websiteURL: URL(string: "http://addisonsgrill.com")!, hours: "11AM - 10PM", location: CLLocationCoordinate2D(latitude: 38.9510, longitude: -92.3278), isOpen: false),
        Restaurant(name: "Flat Branch Pub & Brewing", websiteURL: URL(string: "http://flatbranch.com")!, hours: "11AM - 11PM", location: CLLocationCoordinate2D(latitude: 38.9503, longitude: -92.3289), isOpen: true),
        Restaurant(name: "Murry’s", websiteURL: URL(string: "http://murrysrestaurant.net")!, hours: "11AM - 10PM", location: CLLocationCoordinate2D(latitude: 38.9482, longitude: -92.3258), isOpen: false),
        Restaurant(name: "Logboat Brewing Co.", websiteURL: URL(string: "http://logboatbrewing.com")!, hours: "12PM - 11PM", location: CLLocationCoordinate2D(latitude: 38.9605, longitude: -92.3259), isOpen: true),
        Restaurant(name: "Coley’s American Bistro", websiteURL: URL(string: "http://coleysamericanbistro.com")!, hours: "11AM - 10PM", location: CLLocationCoordinate2D(latitude: 38.9504, longitude: -92.3274), isOpen: true),
        Restaurant(name: "El Rancho", websiteURL: URL(string: "http://elranchocolumbia.com")!, hours: "11AM - 3AM", location: CLLocationCoordinate2D(latitude: 38.9514, longitude: -92.3288), isOpen: true),
        Restaurant(name: "Günter Hans", websiteURL: URL(string: "http://gunterhans.com")!, hours: "2PM - 12AM", location: CLLocationCoordinate2D(latitude: 38.9506, longitude: -92.3279), isOpen: true),
        Restaurant(name: "The Roof", websiteURL: URL(string: "http://theroofcolumbia.com")!, hours: "4PM - 1AM", location: CLLocationCoordinate2D(latitude: 38.9516, longitude: -92.3284), isOpen: true),
        Restaurant(name: "Tropical Liqueurs", websiteURL: URL(string: "http://tropicalliqueurs.com")!, hours: "12PM - 1AM", location: CLLocationCoordinate2D(latitude: 38.9483, longitude: -92.3296), isOpen: true),
        Restaurant(name: "Craft Beer Cellar", websiteURL: URL(string: "http://craftbeercellar.com")!, hours: "11AM - 8PM", location: CLLocationCoordinate2D(latitude: 38.9509, longitude: -92.3282), isOpen: false),
        Restaurant(name: "Room 38 Restaurant & Lounge", websiteURL: URL(string: "http://room-38.com")!, hours: "11AM - 1:30AM", location: CLLocationCoordinate2D(latitude: 38.9505, longitude: -92.3281), isOpen: true),
        Restaurant(name: "Main Squeeze Natural Foods Café", websiteURL: URL(string: "http://mainsqueezecafe.com")!, hours: "9AM - 7PM", location: CLLocationCoordinate2D(latitude: 38.9513, longitude: -92.3277), isOpen: true),
        Restaurant(name: "Sycamore", websiteURL: URL(string: "http://sycamorerestaurant.com")!, hours: "11AM - 10PM", location: CLLocationCoordinate2D(latitude: 38.9512, longitude: -92.3285), isOpen: false),
        Restaurant(name: "Cafe Berlin", websiteURL: URL(string: "http://cafeberlincomo.com")!, hours: "8AM - 2PM", location: CLLocationCoordinate2D(latitude: 38.9521, longitude: -92.3269), isOpen: true)

        // Add more restaurants here
    ]
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

// Make sure to define the `Restaurant` struct and `MultipleSelectionRow` view as needed in your project
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

//struct UIViewControllerRepresentation<Content: View>: UIViewControllerRepresentable {
//    let content: (UIViewController) -> Content
//    
//    init(@ViewBuilder content: @escaping (UIViewController) -> Content) {
//        self.content = content
//    }
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        UIViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        let childView = content(uiViewController)
//        let hostingController = UIHostingController(rootView: childView)
//        uiViewController.addChild(hostingController)
//        uiViewController.view.addSubview(hostingController.view)
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.topAnchor.constraint(equalTo: uiViewController.view.topAnchor),
//            hostingController.view.leadingAnchor.constraint(equalTo: uiViewController.view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: uiViewController.view.trailingAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: uiViewController.view.bottomAnchor)
//        ])
//        hostingController.didMove(toParent: uiViewController)
//    }
//}

