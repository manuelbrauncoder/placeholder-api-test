//
//  PostsView.swift
//  Api-Crud-test
//
//  Created by Manuel Braun on 01.12.24.
//

import SwiftUI

struct PostsView: View {
    
    @State private var posts: [Post] = []
    @StateObject private var api = ApiPlaceholder()
    @State private var postTitle = ""
    @State private var postBody = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add Post") {
                    TextField("title", text: $postTitle)
                    TextField("body", text: $postBody)
                    Button("Save") {
                        addNewPost()
                    }
                    .disabled(postTitle == "" || postBody == "")
                }
                ForEach(posts.sorted { $0.id > $1.id }, id: \.id) { post in
                    Section {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                do {
                    posts = try await api.getAllPosts()
                } catch {
                    print("Error loading posts", error)
                }
            }
        }
    }
    
    private func addNewPost() {
        Task {
            do {
                let newPost = try await api.addNewPost(title: postTitle, body: postBody)
                posts.append(newPost)
                postTitle = ""
                postBody = ""
            } catch {
                print("Error adding new Post", error)
            }
        }
    }
}

#Preview {
    @Previewable @State var post = Post(userId: 1, id: 1, title: "test-title", body: "test-body")
    PostsView()
}
