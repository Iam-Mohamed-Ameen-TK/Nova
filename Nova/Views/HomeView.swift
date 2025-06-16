//
//  MovieListView.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                if !viewModel.movies.isEmpty {
                    
                    // MARK: - Background Poster Image
                    if let url = viewModel.poster(viewModel.movies[viewModel.currentIndex].poster_path) {
                        WebImage(url: url)
                        { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .animation(.easeInOut(duration: 0.5), value: viewModel.currentIndex)
                                .frame(height: 600)
                                .ignoresSafeArea()
                        } placeholder: {
                            ProgressView()
                                .frame(height: 600)
                                .ignoresSafeArea()
                        }
                    }
                    
                    // MARK: - Overlay Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.3), .black]),
                        startPoint: .top,
                        endPoint: .center
                    )
                    .ignoresSafeArea()
                    
                    // MARK: - Foreground Content
                    VStack(spacing: 20) {
                        Spacer()
                        
                        // MARK: - Movie Info Section
                        VStack(spacing: 12) {
                            Text("NEW • MOVIE")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .tracking(2)
                            
                            Text(viewModel.movies[viewModel.currentIndex].title)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
                            
                            Text("Release: \(viewModel.movies[viewModel.currentIndex].release_date)")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.callout)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
                            
                            StarRatingView(rating: viewModel.movies[viewModel.currentIndex].vote_average / 2)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
                        }
                        
                        Spacer().frame(height: 20)
                        
                        // MARK: - Horizontal Scrollable Carousel
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: viewModel.spacing) {
                                    ForEach(Array(viewModel.movies.enumerated()), id: \.element.id) { index, movie in
                                        GeometryReader { geometry in
                                            let frame = geometry.frame(in: .global)
                                            let screenCenter = UIScreen.main.bounds.width / 2
                                            let distance = abs(screenCenter - frame.midX)
                                            
                                            let threshold: CGFloat = viewModel.pageWidth / 2
                                            let scale = distance < threshold ? 1.15 : max(0.85, 1.0 - (distance - threshold) / (viewModel.pageWidth * 1.5))
                                            let opacity = distance < threshold ? 1.0 : max(0.6, 1.0 - (distance - threshold) / (viewModel.pageWidth * 2))
                                            let isCenterItem = distance < threshold
                                            
                                            NavigationLink(value: movie) {
                                                MovieCardView(
                                                    movie: movie,
                                                    index: index,
                                                    scale: scale,
                                                    opacity: opacity,
                                                    isCenterItem: isCenterItem,
                                                    pageWidth: viewModel.pageWidth,
                                                    pageHeight: viewModel.pageHeight,
                                                    colorForMovie: viewModel.colorForMovie
                                                )
                                            }
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.6)) {
                                                    viewModel.currentIndex = index
                                                    proxy.scrollTo(movie.id, anchor: .center)
                                                }
                                            }
                                            .onChange(of: scale) { _, newScale in
                                                if newScale > 1.1 && viewModel.currentIndex != index {
                                                    DispatchQueue.main.async {
                                                        viewModel.currentIndex = index
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: viewModel.pageWidth, height: viewModel.pageHeight + 60)
                                        .id(movie.id)
                                    }
                                }
                                .padding(.horizontal, (UIScreen.main.bounds.width - viewModel.pageWidth) / 2)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo(viewModel.movies[viewModel.currentIndex].id, anchor: .center)
                                    }
                                }
                            }
                            .navigationDestination(for: Movie.self) { movie in
                                let secondVM = MovieDetailViewModel(movie: movie)
                                MovieDetailView(viewModel: secondVM)
                            }
                        }
                        .frame(height: viewModel.pageHeight + 80)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    MovieListView()
}
