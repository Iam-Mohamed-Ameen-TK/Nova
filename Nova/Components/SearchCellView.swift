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
        NavigationLink(
            destination: MovieDetailView(
                viewModel: MovieDetailViewModel(movie: movie)
            ),
            label: {
                HStack(spacing: 10) {
                    if let url = viewModel.poster(movie.poster_path) {
                        WebImage(url: url) { image in
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
                            .lineLimit(3)
                    }

                    Spacer()
                }
                .padding(.vertical, 5)
                .background(Color.black)
            }
        )
    }
}
