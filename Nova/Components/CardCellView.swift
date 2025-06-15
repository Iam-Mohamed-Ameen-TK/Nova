//
//  CardCellView.swift
//  Nova
//
//  Created by Mohamed Ameen on 14/06/25.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let index: Int
    let scale: CGFloat
    let opacity: CGFloat
    let isCenterItem: Bool
    let pageWidth: CGFloat
    let pageHeight: CGFloat
    let colorForMovie: (Int) -> Color
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(colorForMovie(index))
                    .frame(width: pageWidth, height: pageHeight)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                colorForMovie(index).opacity(0.8),
                                colorForMovie(index).opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: pageWidth, height: pageHeight)
                
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                    AsyncImage(url: url)
                    { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: pageWidth, height: pageHeight)
                            .cornerRadius(16)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .cornerRadius(20)
            .shadow(
                color: isCenterItem ? .black.opacity(0.4) : .black.opacity(0.2),
                radius: isCenterItem ? 15 : 8,
                x: 0,
                y: isCenterItem ? 10 : 5
            )
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: scale)
        .animation(.easeInOut(duration: 0.3), value: opacity)
    }
}
