//
//  MovieDetailView.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            posterBackground

            VStack(spacing: 0) {
                Spacer().frame(height: 360)
                movieDetails
            }

            topBar
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Poster Background with Gradient
    @ViewBuilder
    private var posterBackground: some View {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.movie.poster_path)") {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .scaledToFit()
                    .frame(height: 600)
                    .clipped()
                    .ignoresSafeArea()
            } placeholder: {
                ProgressView()
                    .frame(height: 600)
                    .ignoresSafeArea()
            }

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.3), .black]),
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }

    // MARK: - Movie Detail Content
    private var movieDetails: some View {
        VStack(spacing: 16) {
            // Ratings
            HStack(spacing: 32) {
                ratingView(score: String(format: "%.2f", viewModel.movie.vote_average), source: "IMDb")
                ratingView(score: "\(viewModel.movie.vote_count)", source: "Rotten Tomatoes")
                ratingView(score: "\(Int(viewModel.movie.vote_average * 10))%", source: "Metascore")
            }

            Text(viewModel.movie.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                ForEach(viewModel.movie.genre_ids, id: \.self) { id in
                    if let genre = viewModel.genres.first(where: { $0.id == id }) {
                        genreChip(genre.name)
                    }
                }
            }

            Text(viewModel.movie.overview)
                .font(.footnote)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            FavoriteButton(movie: viewModel.movie)
                .padding(.horizontal)
        }
        .padding()
        .background(
            Color.black.opacity(0.9)
                .ignoresSafeArea(edges: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
        .padding(.bottom, -10)
    }

    // MARK: - Top Bar with Dismiss and Language
    private var topBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
            }
            Spacer()

            Text(languageName(from: viewModel.movie.original_language))
                .font(.caption)
                .foregroundColor(.black.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.7))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .offset(y: -5)
    }

    // MARK: - Reusable Rating View
    func ratingView(score: String, source: String) -> some View {
        VStack {
            Text(score)
                .font(.headline)
                .foregroundColor(.white)
            Text(source)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    // MARK: - Genre Chip View
    func genreChip(_ name: String) -> some View {
        Text(name)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }

    // MARK: - Language Converter
    func languageName(from code: String) -> String {
        let locale = Locale(identifier: Locale.current.identifier)
        return locale.localizedString(forLanguageCode: code) ?? code
    }
}
