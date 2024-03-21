//
//  RestaurantDetailView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//
/*
import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    var restaurant: Restaurant
    @Binding var showingDetail: Bool
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: restaurant.location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))), annotationItems: [restaurant]) { place in
                MapPin(coordinate: place.location, tint: .red)
            }
            .onAppear {
              MKMapView.appearance().mapType = .satellite
            }
            .edgesIgnoringSafeArea(.top)
            .frame(height: 300)
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.title)
                Text("Website: \(restaurant.websiteURL.absoluteString)")
                Text("Hours: \(restaurant.hours)")
            }
            .padding()
            
            HStack {
                Button(action: {
                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.location))
                    destination.name = restaurant.name
                    destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
                }) {
                    Text("Open in Maps")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Logic for checking if open could be implemented here
                    print(restaurant.isOpen ? "It's open" : "It's closed")
                    
                }) {
                    Text("Is it open?")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationBarItems(trailing: Button("Back") {
            showingDetail = false
        })
    }
}
*/

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    var restaurant: Restaurant
    @Binding var showingDetail: Bool
    
    // State to control the visibility of the CheckInFormSheet
    @State private var showingCheckInForm = false
    
    var body: some View {
        VStack {
            // Your existing code for the map and details
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: restaurant.location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))), annotationItems: [restaurant]) { place in
                MapPin(coordinate: place.location, tint: .red)
            }
            .onAppear {
              MKMapView.appearance().mapType = .satellite
            }
            .edgesIgnoringSafeArea(.top)
            .frame(height: 300)
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.title)
                Text("Website: \(restaurant.websiteURL.absoluteString)")
                Text("Hours: \(restaurant.hours)")
            }
            .padding()
            
            HStack {
                // Your existing code for the Open in Maps button
                Button(action: {
                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.location))
                    destination.name = restaurant.name
                    destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
                }) {
                    Text("Open in Maps")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                // Modified "Is it open?" button to show the CheckInFormSheet
                Button(action: {
                    showingCheckInForm = true // This triggers the sheet to be presented
                }) {
                    Text("Is it open?")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            .padding()
        }
        .sheet(isPresented: $showingCheckInForm) {
            // Content of the sheet
            CheckInFormSheet(showingFormSheet: $showingCheckInForm)
        }
        .navigationBarItems(trailing: Button("Back") {
            showingDetail = false
        })
    }
}
