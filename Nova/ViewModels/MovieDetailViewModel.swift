//
//  MovieDetailViewModel.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI

@MainActor
class MovieDetailViewModel : ObservableObject {
    @Published var movie: Movie
    @Published var genres : [Genre] = []
    
    init(movie: Movie) {
        self.movie = movie
        self.fetchGenres()
    }
    
    func fetchGenres(){
        let genreURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=0e6e9f8743ac3144e0a43faa485fe233")!
        Task{
            do{
                let (data,_) = try  await URLSession.shared.data(from: genreURL)
                let genreResult = try JSONDecoder().decode(GenreResult.self, from: data)
                genres = genreResult.genres
            }catch{
                print(error.localizedDescription+"popmovie")
            }
        }
    }
}
