//
//  MovieCellView.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchList: View {
    
    var movie: Movie
    @EnvironmentObject var viewModel: MovieListViewModel
    
    var body: some View {
        NavigationStack {
            NavigationLink(value: movie) {
                HStack(spacing: 10) {
                    if let url = viewModel.poster(movie.poster_path) {
                        WebImage(url: url)
                        { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 120) 
                                .clipped()
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 120)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(movie.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(movie.release_date)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.95))
                        
                        Text(movie.overview)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.85))
                            .lineLimit(3) // Limit overview to 3 lines
                    }
                    
                    Spacer()
                    
                }
                .padding(.vertical, 5)
                .background(Color.black)
                .navigationDestination(for: Movie.self) { movie in
                    let secondVM = MovieDetailViewModel(movie: movie)
                    MovieDetailView(viewModel: secondVM)
                }
            }
        }
    }
}
struct SearchList_Previews: PreviewProvider {
    static var previews: some View {
        SearchList(movie: Movie(id: 0, overview: "Sample overview...", poster_path: "/sample.jpg", release_date: "2023-05-01", title: "Sample Movie Title", vote_average : 0, vote_count: 0, original_language: "english", genre_ids: [0]))
            .environmentObject(MovieListViewModel())
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
