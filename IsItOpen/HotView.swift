//
//  HotView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI
import UIKit
struct MyViewController: View {
    
    var body: some View {
        VStack {
            Text("All venues")
        }
        .onAppear {
            // Call the APIManager to fetch data
            APIManager.fetchDataFromAPI { venues in
                // Handle the data received from the API call
                
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

struct HotView: View {
    var body: some View {
        Text("Hotbit")
            .navigationTitle("Hot")
        
        UIViewControllerRepresentation { _ in
                    MyViewController()
                }
            }
        }

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
