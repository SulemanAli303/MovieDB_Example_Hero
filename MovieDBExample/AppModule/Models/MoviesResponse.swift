//
//  MoviesResponse.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 15/02/2024.
//

import Foundation

struct MoviesResponse: Codable {

    let backdropPath: String?
    let id: Int
    let originalTitle, overview: String?

    let posterPath: String?
    let title: String?


    enum CodingKeys: String, CodingKey {

        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case title
    }
        //this can be optimise from configuration api
    var backdropURL:URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(self.backdropPath ?? "")")!
    }
        //this can be optimise from configuration api
    var posterURL:URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(self.posterPath ?? "")")!
    }
}
