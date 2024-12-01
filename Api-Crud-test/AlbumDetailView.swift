//
//  AlbumDetailView.swift
//  Api-Crud-test
//
//  Created by Manuel Braun on 01.12.24.
//

import SwiftUI

struct AlbumDetailView: View {
    
    @StateObject private var api = ApiPlaceholder()
    var albumId: Int
    @State private var isLoading = true
    @State private var ids:[Int] = []
    @State private var photos: [Int: Photo] = [:]
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(ids, id: \.self) { id in
                        if let photo = photos[id] {
                            NavigationLink(destination: PhotoDetailView(photoUrl: photo.url)) {
                                GroupBox {
                                    AsyncImage(url: URL(string: photo.thumbnailUrl))
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } label: {
                                    Label("thumbnail img", systemImage: "photo")
                                }
                                .frame(width: 200, height: 200)
                            }
                        } else {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .task {
                                    await loadPhoto(for: id)
                                }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            ids = getPhotoIds(albumId: albumId)
        }
    }
    func getPhotoIds(albumId: Int) -> [Int] {
        let photosPerAlbum = 50
        let startId = (albumId - 1) * photosPerAlbum + 1
        let endId = startId + photosPerAlbum - 1
        return Array(startId...endId)
    }
    
    @MainActor
    private func loadPhoto(for id: Int) async {
        do {
            let photo = try await api.getImageForId(id: id)
            photos[id] = photo
        } catch {
            print("Failed to load photo for id \(id): \(error)")
        }
    }
}


#Preview {
    AlbumDetailView(albumId: 1)
}
