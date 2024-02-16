//
//  BaseResponse.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 15/02/2024.
//

import Foundation

struct BaseResponse<T:Codable>: Codable {
    let page: Int
    let results: [T]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
