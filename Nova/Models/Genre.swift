//
//  Genre.swift
//  Nova
//
//  Created by Mohamed Ameen on 15/06/25.
//

import Foundation

struct Genre: Decodable, Identifiable {
    var id : Int
    var name: String
}

struct GenreResult: Decodable {
    let genres: [Genre]
}
