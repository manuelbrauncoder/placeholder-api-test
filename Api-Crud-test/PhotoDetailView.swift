//
//  PhotoDetailView.swift
//  Api-Crud-test
//
//  Created by Manuel Braun on 01.12.24.
//

import SwiftUI

struct PhotoDetailView: View {
    
    var photoUrl: String
    
    var body: some View {
        Text("Foto mit maximaler Auflösung")
        AsyncImage(url: URL(string: photoUrl)) { image in
            image.resizable().frame(width: 300, height: 300)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    PhotoDetailView(photoUrl: "https://via.placeholder.com/600/92c952")
}
