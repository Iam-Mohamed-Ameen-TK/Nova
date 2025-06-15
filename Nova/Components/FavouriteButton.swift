//
//  FavouriteButton.swift
//  Nova
//
//  Created by Mohamed Ameen on 14/06/25.
//

import SwiftUI

struct FavoriteButton: View {
    @State private var isFavorited = false
    let movie: Movie

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                isFavorited.toggle()
                if isFavorited {
                    CoreDataManager.shared.addToFavorites(movie: movie)
                } else {
                    CoreDataManager.shared.removeFromFavorites(id: movie.id)
                }
            }
        }) {
            HStack {
                Text(isFavorited ? "Added to Favorites" : "Tap to Add Favourite")
                    .fontWeight(.bold)
                Image(systemName: isFavorited ? "heart.fill" : "heart")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isFavorited ? Color.red : Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFavorited ? Color.red : Color.white, lineWidth: 1)
            )
        }
        .onAppear {
            isFavorited = CoreDataManager.shared.isFavorited(id: movie.id)
        }
    }
}
