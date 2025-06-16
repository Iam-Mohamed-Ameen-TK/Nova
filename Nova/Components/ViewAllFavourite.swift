//
//  ViewAllFavourite.swift
//  Nova
//
//  Created by Mohamed Ameen on 15/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct AllFavoritesSheet: View {
    @State private var localFavorites: [FavoriteMovie]
    @Environment(\.presentationMode) private var presentationMode
    var action: (() -> Void)?

    // Initializes localFavorites with passed-in data
    init(favorites: [FavoriteMovie], action: (() -> Void)? = nil) {
        self._localFavorites = State(initialValue: favorites)
        self.action = action
    }

    var body: some View {
        NavigationView {
            Group {
                if localFavorites.isEmpty {
                    // Placeholder view when there are no favorite movies
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)

                        Text("No Favorites Yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(localFavorites, id: \.self) { movie in
                            HStack(spacing: 20) {
                                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.poster_path ?? "")")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(10)
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(10)
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(movie.title ?? "")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(movie.overview ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.75))
                                        .lineLimit(3)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.clear)
                            .listStyle(PlainListStyle())
//                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                Button {
//                                    // Deletes the selected movie from Core Data and local list
//                                    if let index = localFavorites.firstIndex(of: movie) {
//                                        deleteMovie(at: IndexSet(integer: index))
//                                    }
//                                } label: {
//                                    Label {
//                                        Text("Delete")
//                                    } icon: {
//                                        Image(systemName: "trash")
//                                    }
//                                }
//                            }
                        }
                        .onDelete(perform: deleteMovie)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("All Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    

    // Removes movie from Core Data and updates localFavorites
    private func deleteMovie(at offsets: IndexSet) {
        for index in offsets {
            let movie = localFavorites[index]
            let id = Int(movie.id)
            CoreDataManager.shared.removeFromFavorites(id: id)
        }
        localFavorites.remove(atOffsets: offsets)
        action?()
    }
}
