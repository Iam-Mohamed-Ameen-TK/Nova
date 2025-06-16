//
//  SearchPosterView.swift
//  Nova
//
//  Created by Mohamed Ameen on 14/06/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchPosterView: View {
    let movie: Movie
    let url: URL

    var body: some View {
        NavigationLink(value: movie) {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(height: 300)
            }
        }
    }
}
