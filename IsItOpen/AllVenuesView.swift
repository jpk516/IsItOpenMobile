//
//  AllVenuesView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 3/19/24.
//

import SwiftUI

struct AllVenuesView: View {
    let venues: [Venue]

    var body: some View {
        List(venues) { venue in
            Link(destination: URL(string: venue.url)!) {
                Text(venue.name)
            }
        }
        .navigationTitle("All Venues")
    }
}
