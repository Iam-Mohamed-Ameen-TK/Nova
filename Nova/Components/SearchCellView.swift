//
//  MovieCellView.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

//import SwiftUI
//import SDWebImageSwiftUI
//
//struct SearchList: View {
//    
//    var movie: Movie
//    @EnvironmentObject var viewModel: MovieListViewModel
//    
//    var body: some View {
//        NavigationView {
//            NavigationLink(value: movie) {
//                HStack(spacing: 10) {
//                    if let url = viewModel.poster(movie.poster_path) {
//                        WebImage(url: url)
//                        { image in
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 80, height: 120) 
//                                .clipped()
//                                .cornerRadius(8)
//                        } placeholder: {
//                            ProgressView()
//                                .frame(width: 80, height: 120)
//                        }
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text(movie.title)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        
//                        Text(movie.release_date)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.95))
//                        
//                        Text(movie.overview)
//                            .font(.caption)
//                            .foregroundColor(.white.opacity(0.85))
//                            .lineLimit(3) // Limit overview to 3 lines
//                    }
//                    
//                    Spacer()
//                    
//                }
//                .padding(.vertical, 5)
//                .background(Color.black)
//                .navigationDestination(for: Movie.self) { movie in
//                    let secondVM = MovieDetailViewModel(movie: movie)
//                    MovieDetailView(viewModel: secondVM)
//                }
//            }
//        }
//    }
//}
//struct SearchList_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchList(movie: Movie(id: 0, overview: "Sample overview...", poster_path: "/sample.jpg", release_date: "2023-05-01", title: "Sample Movie Title", vote_average : 0, vote_count: 0, original_language: "english", genre_ids: [0]))
//            .environmentObject(MovieListViewModel())
//            .preferredColorScheme(.dark)
//            .previewLayout(.sizeThatFits)
//    }
//}

//import SwiftUI
//import SDWebImageSwiftUI
//
//struct SearchList: View {
//    
//    var movie: Movie
//    @EnvironmentObject var viewModel: MovieListViewModel
//    
//    var body: some View {
//        NavigationView {
//            NavigationLink(
//                destination: {
//                    let secondVM = MovieDetailViewModel(movie: movie)
//                    MovieDetailView(viewModel: secondVM)
//                },
//                label: {
//                    HStack(spacing: 10) {
//                        // Replace single poster with horizontal scrollable gallery
//                        // Option 1: If you have multiple poster paths in an array
////                        if let posterPaths = movie.poster_paths, !posterPaths.isEmpty {
////                            ScrollView(.horizontal, showsIndicators: false) {
////                                HStack {
////                                    ForEach(posterPaths, id: \.self) { path in
////                                        if let url = viewModel.poster(path) {
////                                            WebImage(url: url) { image in
////                                                image
////                                                    .resizable()
////                                                    .scaledToFill()
////                                                    .frame(width: 80, height: 120)
////                                                    .clipped()
////                                                    .cornerRadius(8)
////                                            } placeholder: {
////                                                ProgressView()
////                                                    .frame(width: 80, height: 120)
////                                            }
////                                        }
////                                    }
////                                }
////                            }
////                        }
//                        // Option 2: If you only have a single poster_path, keep original code
//                        /*else*/ if let url = viewModel.poster(viewModel.movies[viewModel.currentIndex].poster_path) {
//                            WebImage(url: url) { image in
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 80, height: 120)
//                                    .clipped()
//                                    .cornerRadius(8)
//                            } placeholder: {
//                                ProgressView()
//                                    .frame(width: 80, height: 120)
//                            }
//                        }
////                        .frame(height: 120) // Set fixed height for the scroll view
//
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text(movie.title)
//                                .font(.headline)
//                                .foregroundColor(.white)
//
//                            Text(movie.release_date)
//                                .font(.subheadline)
//                                .foregroundColor(.white.opacity(0.95))
//
//                            Text(movie.overview)
//                                .font(.caption)
//                                .foregroundColor(.white.opacity(0.85))
//                                .lineLimit(3)
//                        }
//
//                        Spacer()
//                    }
//                    .padding(.vertical, 5)
//                    .background(Color.black)
//                }
//            )
//            .navigationBarTitle("Movie", displayMode: .inline)
//        }
//    }
//}

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
