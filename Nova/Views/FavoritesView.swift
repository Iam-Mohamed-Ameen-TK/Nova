//
//  FavoritesView.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesView: View {
    // MARK: - Properties
    @State private var favorites: [FavoriteMovie] = []
    @State private var currentIndex: Int = 0
    @State private var showAllFavorites = false
    @State private var selectedMovie: Movie?
    @State private var isShowingDetail = false

    var body: some View {
        // MARK: - Main View
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                if favorites.isEmpty {
                    // MARK: - Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)

                        Text("No Favorites Yet")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Your favorite movies will appear here once you add them.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    VStack(alignment: .leading) {
                        VStack(spacing: 20) {
                            headerSection
                            carouselSection
                        }
                        .offset(y: -50)

                        Spacer()
                    }
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44)
                    .padding()
                }

                // NavigationLink fallback
                NavigationLink(
                    destination: Group {
                        if let movie = selectedMovie {
                            MovieDetailView(viewModel: MovieDetailViewModel(movie: movie))
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $isShowingDetail
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                favorites = CoreDataManager.shared.getFavorites()
               
            }
            .sheet(isPresented: $showAllFavorites) {
                AllFavoritesSheet(favorites: favorites, action: {
                    favorites = CoreDataManager.shared.getFavorites()
                })
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                favorites = CoreDataManager.shared.getFavorites()
                if currentIndex >= favorites.count {
                    currentIndex = max(0, favorites.count - 1)
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            Text("Your Favorite Picks")
                .fontWeight(.heavy)
                .font(.system(size: 25))
                .foregroundColor(.white)

            Text("Swipe to browse your loved movies")
                .padding(.horizontal, 30)
                .foregroundColor(.white.opacity(0.75))
        }
    }

    // MARK: - Carousel Section
    private var carouselSection: some View {
        ZStack {
            Circle()
                .foregroundColor(.gray.opacity(0.3))
                .frame(width: 300, height: 400)

            posterStack
            arrowButtons
            viewAllOverlay
        }
        .offset(y: -80)
    }

    // MARK: - Poster Stack with Swipe
    private var posterStack: some View {
        ForEach(favorites.indices, id: \.self) { index in
            let offset = CGFloat(index - currentIndex)
            let isCurrent = index == currentIndex

            poster(for: favorites[index], width: isCurrent ? 150 : 140, height: isCurrent ? 200 : 160)
                .scaleEffect(isCurrent ? 1.1 : 0.9)
                .rotationEffect(.degrees(
                    offset == -1 ? -30 :
                    offset == 1 ? 30 : 0
                ))
                .offset(x: offset * 80, y: -15)
                .opacity(abs(offset) <= 1 ? 1 : 0)
                .zIndex(isCurrent ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                .onTapGesture {
                    if isCurrent {
                        let movie = convertToMovie(from: favorites[index])
                        selectedMovie = movie
                        isShowingDetail = true
                    }
                }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if value.translation.width < -30, currentIndex < favorites.count - 1 {
                            currentIndex += 1
                        } else if value.translation.width > 30, currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                }
        )
    }

    // MARK: - Arrow Buttons
    private var arrowButtons: some View {
        HStack {
            if currentIndex > 0 {
                Button(action: {
                    withAnimation {
                        currentIndex -= 1
                    }
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
            } else {
                Spacer().frame(width: 40)
            }

            Spacer()

            if currentIndex < favorites.count - 1 {
                Button(action: {
                    withAnimation {
                        currentIndex += 1
                    }
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
            } else {
                Spacer().frame(width: 40)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 210)
    }

    // MARK: - View All Overlay
    private var viewAllOverlay: some View {
        VStack {
            Spacer()

            if favorites.indices.contains(currentIndex) {
                Text(favorites[currentIndex].title ?? "")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 250)

                Button(action: {
                    showAllFavorites = true
                }) {
                    Text("View All")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 80)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                }
                .offset(y: 10)
            }
        }
    }

    // MARK: - Poster Image View
    @ViewBuilder
    private func poster(for movie: FavoriteMovie, width: CGFloat, height: CGFloat) -> some View {
        if let path = movie.poster_path,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .cornerRadius(10)
            } placeholder: {
                Color.gray
                    .frame(width: width, height: height)
                    .cornerRadius(10)
            }
        } else {
            Color.gray
                .frame(width: width, height: height)
                .cornerRadius(10)
        }
    }

    // MARK: - Helper: Convert FavoriteMovie to Movie
    private func convertToMovie(from favorite: FavoriteMovie) -> Movie {
        return Movie(
            id: Int(favorite.id),
            overview: favorite.overview ?? "",
            poster_path: favorite.poster_path ?? "",
            release_date: favorite.release_date ?? "",
            title: favorite.title ?? "",
            vote_average: favorite.vote_average,
            vote_count: 0,
            original_language: "en",
            genre_ids: []
        )
    }
}
