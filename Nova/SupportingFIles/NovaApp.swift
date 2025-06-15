//
//  NovaApp.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI
import CoreData

@main
struct NovaApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    MainTabView()
                        .environmentObject(MovieListViewModel())
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}
