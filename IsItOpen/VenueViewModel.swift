//
//  VenueViewModel.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

import SwiftUI

// ViewModel to handle fetching and storing data
class VenueViewModel: ObservableObject {
    @Published var venues: [Venue] = []

    func loadVenues() {
        APIManager.fetchDataFromAPI { [weak self] fetchedVenues in
            DispatchQueue.main.async {
                self?.venues = fetchedVenues
                
            }
        }
    }
}

// SwiftUI View to display venues
struct VenueListView: View {
    @ObservedObject var viewModel = VenueViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.venues, id: \.id) { venue in
                VStack(alignment: .leading) {
                    Text(venue.name).font(.headline)
                    Text(venue.description).font(.subheadline)
                }
            }
            .navigationTitle("Venues")
            .onAppear {
                viewModel.loadVenues()
            }
        }
    }
}


