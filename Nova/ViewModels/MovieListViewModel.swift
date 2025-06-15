//
//  MovieListViewModel.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI
import Foundation

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies : [Movie] = []
    @Published var currentIndex: Int = 0
    @Published var search : [Movie] = []
    

    let pageWidth: CGFloat = 220
    let pageHeight: CGFloat = 300
    let spacing: CGFloat = 30

    
    init() {
        self.fetchPopularMovie()
    }
    
    func colorForMovie(at index: Int) -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink]
        return colors[index % colors.count]
    }
    
    
    
    func fetchPopularMovie(){
        let popularMovieURL = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=0e6e9f8743ac3144e0a43faa485fe233")!
        Task{
            do{
                let (data,_) = try  await URLSession.shared.data(from: popularMovieURL)
                let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
                movies = movieResult.results
            }catch{
                print(error.localizedDescription+"popmovie")
            }
        }
    }
    
    func poster(_ path:String)-> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    
    }
    
    func search(keyword:String){
        let seachURL = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(keyword)&api_key=0e6e9f8743ac3144e0a43faa485fe233")!
        print(seachURL)
        Task{
            do{
                let (data,_) = try await URLSession.shared.data(from: seachURL)
                let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
                search = movieResult.results
            }catch{
                print(error.localizedDescription+"upcoming")
            }
        }
    }
}
