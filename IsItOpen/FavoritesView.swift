////
////  FavoritesView.swift
////  IsItOpen
////
////  Created by Jimmy Keating on 4/29/24.
////
//
//import SwiftUI
//import CoreLocation
//import MapKit
//
//struct FavoritesView: View {
//    @StateObject var venueViewModel = VenueViewModel() // ViewModel to manage venue data
//    @State private var showingDetail = false
//    @State private var selectedVenue: Venue?
//
//    // State for form inputs (assuming these are used in some form views you have)
//    @State private var isOpen: String = ""
//    @State private var atmosphereTags: Set<String> = []
//
//    var body: some View {
//        NavigationView {
//            List(venueViewModel.venues, id: \.id) { venue in
//                HStack {
//                    Image(systemName: "circle.fill") // Example image, adjust as needed
//                        .foregroundColor(venue.active ? .green : .red)
//
//                    Button(venue.name) {
//                        self.selectedVenue = venue
//                    }
//                    .sheet(item: $selectedVenue) { venue in
//                        VenueDetailView(venue: venue, showingDetail: $showingDetail)
//                    }
//                }
//            }
//            .navigationTitle("Is it Open?")
//            .onAppear {
//                venueViewModel.loadVenues() // Load venues when the view appears
//            }
//        }
//    }
//}
//
//
//struct FavoritesDetailView: View {
//    var venue: Venue
//    @Binding var showingDetail: Bool
//    // State to control the visibility of additional sheets or actions
//    @State private var showingCheckInForm = false
//    
//    var body: some View {
//        VStack {
//            MapView(venue: venue) // Assume MapView is defined elsewhere
//                .edgesIgnoringSafeArea(.top)
//                .frame(height: 300)
//            
//            VStack(alignment: .leading) {
//                Text(venue.name)
//                    .font(.title)
//                //Text("Website: \(venue.website)")
//                Text(formattedHours(venue.hours))
//            }
//            .padding()
//            
//            HStack {
//                Button(action: {
//                    openInMaps(venue: venue)
//                }) {
//                    Text("Open in Maps")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                Button(action: {
//                    showingCheckInForm = true // This triggers the sheet to be presented
//                }) {
//                    Text("Is it open?")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                
//            }
//            .padding()
//        }
//        .sheet(isPresented: $showingCheckInForm) {
//            // Content of the sheet
//            CheckInFormSheet(showingFormSheet: $showingCheckInForm)
//        }
//        .navigationBarItems(trailing: Button("Back") {
//            showingDetail = false
//        })
//        
//        Button(action: {
//            if let url = URL(string: "tel://\(venue.phone)") {
//                UIApplication.shared.open(url)
//            }
//        }) {
//            Text("Call Venue")
//                .padding()
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//        }
//        
//        if let url = URL(string: "http://\(venue.website)"), UIApplication.shared.canOpenURL(url) {
//            Button(action: {
//                UIApplication.shared.open(url)
//            }) {
//                Text("Visit Website")
//                    .padding()
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//        }
//}
//
//    private func formattedHours(_ hours: [Venue.Hours]) -> String {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "h:mm a"  // "5:30 PM"
//            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // Assuming times are in UTC
//
//            return hours.map { hour -> String in
//                let openString = hour.open != nil ? dateFormatter.string(from: hour.open!) : "Closed"
//                let closeString = hour.close != nil ? dateFormatter.string(from: hour.close!) : "Closed"
//                return "\(hour.day): \(openString) - \(closeString)"
//            }
//            .joined(separator: "\n")
//        }
//    
//
//    
//
//    private func hourString(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//
//    private func openInMaps(venue: Venue) {
//        // Extract coordinates from Venue's geo data
//        let coordinate = CLLocationCoordinate2D(latitude: venue.geo.coordinates[1], longitude: venue.geo.coordinates[0])
//        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
//        destination.name = venue.name
//        destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
//    }
//
//}
//
//
//
//


import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Favorites] = []

    func loadFavorites() {
        APIManager.fetchDataFromFavAPI { [weak self] favorites in
            DispatchQueue.main.async {
                self?.favorites = favorites
            }
        }
    }
}

import SwiftUI
import CoreLocation
import MapKit

struct FavoritesView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @State private var showingDetail = false
    @State private var selectedFavorite: Favorites?

    var body: some View {
        NavigationView {
            List(favoritesViewModel.favorites, id: \.id) { favorite in
                HStack {
                    Image(systemName: "star.fill") // Changed to star for favorites
                        .foregroundColor(favorite.active ? .yellow : .gray)

                    Button(favorite.name) {
                        self.selectedFavorite = favorite
                    }
                    .sheet(item: $selectedFavorite) { favorite in
                        FavoritesDetailView(favorite: favorite, showingDetail: $showingDetail)
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                favoritesViewModel.loadFavorites() // Load favorite venues when the view appears
            }
        }
    }
}

struct FavoritesDetailView: View {
    var favorite: Favorites
    @Binding var showingDetail: Bool

    var body: some View {
        VStack {
            // Assume you have a map view or other details to show here
            Text(favorite.name).font(.headline)
            Text("Details here...").padding()
            Button("Close") {
                showingDetail = false
            }
        }
    }
}
