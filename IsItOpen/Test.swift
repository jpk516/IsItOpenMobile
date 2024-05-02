//
//  Test.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 5/1/24.
//

import SwiftUI

struct TagsView: View {
    @State private var tags: [Tags] = []

    var body: some View {
        VStack {
            if tags.isEmpty {
                ProgressView("Loading Tags...")
            } else {
                List(tags, id: \.id) { tag in
                    Text(tag.name)
                }
            }
        }
        .onAppear {
            APIManager.fetchDataFromTagAPI { fetchedTags in
                if let fetchedTags = fetchedTags {
                    tags = fetchedTags
                } else {
                    // Handle error or show appropriate message
                }
            }
        }
    }
}
