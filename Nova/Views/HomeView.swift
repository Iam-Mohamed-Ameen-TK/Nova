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
    @State private var shouldScrollToCurrentIndex = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                if !viewModel.movies.isEmpty {
                    
                    // MARK: - Background Poster Image
                    if let url = viewModel.poster(viewModel.movies[viewModel.currentIndex].poster_path) {
                        WebImage(url: url)
                        { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .animation(.spring(response: 0.8, dampingFraction: 0.9, blendDuration: 0.3), value: viewModel.currentIndex)
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
                                .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.2), value: viewModel.currentIndex)
                            
                            Text("Release: \(viewModel.movies[viewModel.currentIndex].release_date)")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.callout)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.2), value: viewModel.currentIndex)
                            
                            StarRatingView(rating: viewModel.movies[viewModel.currentIndex].vote_average / 2)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.2), value: viewModel.currentIndex)
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
                                            
                                            NavigationLink(
                                                destination: MovieDetailView(viewModel: MovieDetailViewModel(movie: movie))
                                            ) {
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
                                                // Update current index when tapped
                                                viewModel.currentIndex = index
                                                withAnimation(.spring(response: 0.8, dampingFraction: 0.75, blendDuration: 0.3)) {
                                                    proxy.scrollTo(movie.id, anchor: .center)
                                                }
                                            }
                                            .onChange(of: scale) { newScale in
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
                                    withAnimation(.spring(response: 0.9, dampingFraction: 0.85, blendDuration: 0.2)) {
                                        proxy.scrollTo(viewModel.movies[viewModel.currentIndex].id, anchor: .center)
                                    }
                                }
                            }
                            .onChange(of: viewModel.currentIndex) { newIndex in
                                withAnimation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.2)) {
                                    proxy.scrollTo(viewModel.movies[newIndex].id, anchor: .center)
                                }
                            }
                            .onChange(of: shouldScrollToCurrentIndex) { shouldScroll in
                                if shouldScroll {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.spring(response: 0.8, dampingFraction: 0.85, blendDuration: 0.3)) {
                                            proxy.scrollTo(viewModel.movies[viewModel.currentIndex].id, anchor: .center)
                                        }
                                        shouldScrollToCurrentIndex = false
                                    }
                                }
                            }
                        }
                        .frame(height: viewModel.pageHeight + 80)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Trigger scroll restoration when view appears
                shouldScrollToCurrentIndex = true
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Force single view on iPad
    }
}

// MARK: - iOS 14 Preview
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
            .preferredColorScheme(.dark)
    }
}
