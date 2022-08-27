//
//  MovieStruct.swift
//  Movie Data
//
//  Created by Константин Малков on 24.06.2022.
//

import Foundation

struct Root: Decodable {
    let docs: [Docs]
    enum CodingKeys: String, CodingKey {
        case docs = "docs"
    }
}

struct Docs: Codable {
    let rating: Rating
    let poster: Poster
    let id: Int
    let type: String
    let name: String
    let description: String?
    let year: Int
    let movieLength: Int?
    let alternativeName: String?
}

struct Poster: Codable {
    let url: String?
    let previewUrl: String
    
}
struct Rating: Codable {
    let kp: Double
    let imdb: Double
    
    
}

