//
//  SearchBarView.swift
//  Nova
//
//  Created by Mohamed Ameen on 14/06/25.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    @EnvironmentObject var viewModel: MovieListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - Search Bar
                HStack {
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty {
                            Text("Search")
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(.leading, 15)
                        }

                        TextField("", text: $searchText)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.clear)
                            .onChange(of: searchText) { newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if newValue == searchText {
                                        viewModel.search(keyword: newValue)
                                    }
                                }
                            }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.top, 10)
                .padding(.horizontal)
                
                // MARK: - Conditional Movie Lists
                if searchText.isEmpty {
                    // MARK: - Top Searches
                    VStack(alignment: .leading) {
                        Text("Top Search")
                            .fontWeight(.heavy)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        List(viewModel.movies, id: \.id) { movie in
                            SearchList(movie: movie)
                                .listRowBackground(Color.black)
                        }
                        .listStyle(.plain)
                        .background(Color.black)
                    }
                } else {
                    // MARK: - Search Results Grid
                    VStack(alignment: .leading) {
                        Text("Movies & TV")
                            .fontWeight(.heavy)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 20) {
                                ForEach(viewModel.search, id: \.id) { movie in
                                    if let url = viewModel.poster(movie.poster_path) {
                                        SearchPosterView(movie: movie, url: url)
                                    }
                                }
                            }
                            .padding()
                            .navigationDestination(for: Movie.self) { movie in
                                let secondVM = MovieDetailViewModel(movie: movie)
                                MovieDetailView(viewModel: secondVM)
                            }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .onAppear {
                viewModel.fetchPopularMovie()
            }
        }
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(MovieListViewModel())
            .preferredColorScheme(.dark)
    }
}
