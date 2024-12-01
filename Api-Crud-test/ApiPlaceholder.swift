//
//  ApiPlaceholder.swift
//  Api-Crud-test
//
//  Created by Manuel Braun on 01.12.24.
//

import Foundation

enum HttpError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct Album: Codable {
    var userId: Int
    var id: Int
    var title: String
}

struct Photo: Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}


class ApiPlaceholder: ObservableObject {
    
    let baseUrl = "https://jsonplaceholder.typicode.com"
    @Published var albumTitles: [Int: String] = [:]
    
    func loadAlbumTitle(for albumId: Int) async {
        do {
            let title = try await getAlbumForId(albumId: albumId).title
            DispatchQueue.main.async {
                self.albumTitles[albumId] = title
            }
        } catch {
            print("Error loading Album Title for id: \(albumId), error: \(error)")
        }
    }
    
    func getAlbumTitle(for albumId: Int) -> String? {
        return albumTitles[albumId]
    }
    
    func getAlbumForId(albumId: Int) async throws -> Album {
        
        let urlString = "\(baseUrl)/albums/\(albumId)"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            return try JSONDecoder().decode(Album.self, from: data)
        } catch {
            throw HttpError.invalidData
        }
    }
    
    func getImageForId(id: Int) async throws -> Photo {
        
        let urlString = "\(baseUrl)/photos/\(id)"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            return try JSONDecoder().decode(Photo.self, from: data)
        } catch {
            throw HttpError.invalidData
        }
    }
    
    func getPhotosForAlbum(albumId: Int) async throws -> [Photo] {
        
        let urlString = "\(baseUrl)/photos?albumId=\(albumId)"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            return try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            throw HttpError.invalidData
        }
    }
    
    func getAllPosts() async throws -> [Post] {
        
        let urlString = "\(baseUrl)/posts"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            return try JSONDecoder().decode([Post].self, from: data)
        } catch {
            throw HttpError.invalidData
        }
    }
    
    func addNewPost(title: String, body: String) async throws -> Post {
        
        let urlString = "\(baseUrl)/posts"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let postData = Post(userId: 1, id: 0, title: title, body: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(postData)
        } catch {
            throw HttpError.invalidData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw HttpError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Post.self, from: data)
        } catch {
            throw HttpError.invalidData
        }
    }
}
