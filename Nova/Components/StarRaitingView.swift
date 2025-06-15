//
//  StarRaitingView.swift
//  Nova
//
//  Created by Mohamed Ameen on 14/06/25.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                let starValue = Double(index + 1)
                Image(systemName: rating >= starValue ? "star.fill" :
                      rating >= starValue - 0.5 ? "star.leadinghalf.filled" :
                      "star")
                    .foregroundColor(.yellow)
                    .font(.system(size: 14))
            }
        }
    }
}

#Preview {
    StarRatingView(rating: 0.1)
}
