//
//  Restaurant.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import Foundation
import CoreLocation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let websiteURL: URL
    let hours: String
    let location: CLLocationCoordinate2D
    var isOpen: Bool
}
