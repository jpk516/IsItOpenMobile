//
//  MainView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 3/19/24.
//
import SwiftUI
import MapKit
import Foundation
import SwiftUI
import CoreLocation

struct Venue: Identifiable {
    var id = UUID()
    var name: String
    var isOpen: Bool
    var location: CLLocationCoordinate2D
    var url: String
}



struct MainView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), latitudinalMeters: 50000, longitudinalMeters: 50000)
    @State private var selectedVenue: Venue?

    let venues: [Venue] = [
        Venue(name: "Harpo's", isOpen: true, location: CLLocationCoordinate2D(latitude: 38.95064794213455, longitude: -92.32681850984262), url: "about:blank"),
        Venue(name: "The Old Heidelberg", isOpen: false, location: CLLocationCoordinate2D(latitude: 38.94702278652283, longitude: -92.32745927316932), url: "about:blank")
    ]

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: venues) { venue in
                MapAnnotation(coordinate: venue.location) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.region.center = venue.location
                            }
                        Text(venue.name)
                            .font(.caption)
                    }
                }
            }
            .frame(height: 300)
            
            List(venues) { venue in
                HStack {
                    Text(venue.name)
                    Spacer()
                    Image(systemName: venue.isOpen ? "circle.fill" : "circle")
                        .foregroundColor(venue.isOpen ? .green : .red)
                }
                .onTapGesture {
                    self.region.center = venue.location
                    self.selectedVenue = venue
                }
            }
        }
        .navigationTitle("Is it Open")
    }
}

