//
//  TabView.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var movieViewModel = MovieListViewModel()
    
    init() {
            UITabBar.appearance().barTintColor = UIColor.black
            UITabBar.appearance().backgroundColor = UIColor.black
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    
    var body: some View {
        TabView {
            MovieListView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            SearchView()
                .environmentObject(movieViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
        .tint(.red)
    }
}


#Preview {
    MainTabView()
}
