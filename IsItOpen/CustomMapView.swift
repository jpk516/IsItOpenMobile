//
//  CustomMapView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 3/19/24.
//

import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable {
    let venues: [Venue]
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        
        // Remove all existing annotations to avoid duplicates
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotations
        let annotations = venues.map { venue -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = venue.name
            annotation.coordinate = venue.location
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(parent: CustomMapView) {
            self.parent = parent
        }

        // Implement MKMapViewDelegate methods if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
