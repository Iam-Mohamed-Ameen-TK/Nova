//
//  SplashScreen.swift
//  Nova
//
//  Created by Mohamed Ameen on 15/06/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var imageScale: CGFloat = 0.8
    @State private var imageOpacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Image("Splash")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .scaleEffect(imageScale)
                .opacity(imageOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        imageScale = 1.0
                        imageOpacity = 1.0
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            MainTabView()
                .environmentObject(MovieListViewModel())
                .transition(.opacity)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .environmentObject(MovieListViewModel())
    }
}
