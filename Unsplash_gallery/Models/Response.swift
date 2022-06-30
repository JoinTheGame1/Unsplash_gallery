//
//  Response.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation

struct PhotosResponse: Codable {
    let results: [Photo]?
}

struct Photo: Codable {
    let id: String?
    let downloads: Int?
    let likes: Int?
    let description: String?
    let user: User?
    let urls: Urls?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, downloads, likes, description, user, urls
        case createdAt = "created_at"
    }
}
struct Urls: Codable {
    let raw, full, regular, small, thumb: String?
}

struct User: Codable {
    let location: String?
}
