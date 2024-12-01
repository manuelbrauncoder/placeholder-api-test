//
//  ContentView.swift
//  Api-Crud-test
//
//  Created by Manuel Braun on 01.12.24.
//

import SwiftUI

struct AlbumView: View {
    
    @StateObject private var api = ApiPlaceholder()
    private let ids = Array(1...100)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ids, id: \.self) { albumId in
                    NavigationLink(destination: AlbumDetailView(albumId: albumId)) {
                        if let title = api.getAlbumTitle(for: albumId) {
                            Text(title)
                        } else {
                            ProgressView()
                        }
                    }
                    .task {
                        await api.loadAlbumTitle(for: albumId)
                    }
                }
            }
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AlbumView()
}
