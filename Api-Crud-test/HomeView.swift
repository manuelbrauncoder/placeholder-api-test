//
//  HomeView.swift
//  Api-Crud-test
//
//  Created by Manuel Braun on 01.12.24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Albums", systemImage: "photo") {
                AlbumView()
            }
            Tab("Posts", systemImage: "text.page") {
                PostsView()
            }
        }
    }
}

#Preview {
    HomeView()
}
