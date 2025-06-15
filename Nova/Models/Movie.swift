//
//  Moview.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import Foundation

struct MovieResult : Decodable {
    let page : Int
    let results : [Movie]
    let total_pages : Int
    let total_results : Int
}

struct Movie: Hashable, Decodable, Identifiable {
    var id : Int
    var overview : String
    var poster_path : String
    var release_date :String
    var title : String
    var vote_average: Double
    var vote_count: Int
    var original_language: String
    var genre_ids: [Int]
}

