//
//  MovieModel.swift
//  MovieModel
//
//  Created by admin on 18.07.2022.
//

import Foundation

struct Data: Decodable {
    var items: [MovieModel] = []
}


struct MovieModel: Decodable {
    
    var id: String = ""
    var rank: String = ""
    var title: String = ""
    var fullTitle: String = ""
    var year: String = ""
    var image: String = ""
    var crew: String = ""
    var imDbRating: String = ""
    var imDbRatingCount: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case rank = "rank"
        case title = "title"
        case fullTitle = "fullTitle"
        case year = "year"
        case image = "image"
        case crew = "crew"
        case imDbRating = "imDbRating"
        case imDbRatingCount = "imDbRatingCount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        rank = try container.decode(String.self, forKey: .rank)
        title = try container.decode(String.self, forKey: .title)
        fullTitle = try container.decode(String.self, forKey: .fullTitle)
        year = try container.decode(String.self, forKey: .year)
        image = try container.decode(String.self, forKey: .image)
        crew = try container.decode(String.self, forKey: .crew)
        imDbRating = try container.decode(String.self, forKey: .imDbRating)
        imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
    }
}
