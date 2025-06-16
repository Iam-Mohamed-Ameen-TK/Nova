
# Nova

**Nova** is a beautiful and immersive movie discovery app built using **Swift**, **SwiftUI**, and **Core Data**. It fetches movie data from the [TMDB API](https://www.themoviedb.org/documentation/api) and allows users to explore popular titles, view detailed information, and save favorites locally.

---

## Features

- Splash Screen: Engaging intro screen before navigating to the main app.
- Home View:
  - Displays popular movies fetched from TMDB.
  - Shows movie title, poster image, and star rating.
  - Posters are displayed in a horizontal carousel.
  - Tapping a poster navigates to the detail view.
- Detail View:
  - Displays full movie information: language, TMDB rating, Rotten Tomatoes score, Metascore, genre, etc.
  - Includes a button to add or remove movies from favorites using Core Data.
- Favorites View:
  - Features a circular background with swipeable movie cards inside.
  - Swipe and arrow button support for horizontal navigation.
  - Tap any card to navigate to its detail view.
- Favorite List View:
  - Accessible via "View All" in Favorites tab.
  - Displays all saved movies in a scrollable vertical list.
- Search View:
  - Integrated search bar powered by TMDB's search API.
  - Displays search results with navigation to detail views.

---

## App Views

| View                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| SplashScreen        | Launch screen shown when app starts, transitions to HomeView automatically. |
| HomeView            | Displays popular movies in a horizontal carousel with basic details.        |
| DetailView          | Full movie details + button to add/remove from favorites.                   |
| SearchView          | Lets users search for movies using the TMDB API.                            |
| FavoritesView       | Carousel of favorite movie cards inside a circular design.                  |
| FavoriteListView    | Full list of all favorited movies in a vertical scroll layout.              |

---

## Technologies Used

- Language: Swift 5.9
- UI Framework: SwiftUI
- Architecture: MVVM (Model-View-ViewModel)
- Persistence: Core Data (for storing favorite movies)
- Networking: URLSession with async/await
- Image Loading & Caching: SDWebImageSwiftUI
- API: The Movie Database (TMDB) API

---

## Requirements

- Xcode: Version 15 or later
- iOS Deployment Target for App: 14.0 and above
- iOS Deployment Target for Unit Testing (UI & Networking Tests): 17.6 and above
- Swift: Version 5.9
- Internet Connection (for fetching movie data)
- TMDB API Key (if required – add it in the appropriate API client)
- Swift Package Dependency: SDWebImageSwiftUI (add via Xcode Swift Packages)

---

## Installation

To set up and run Nova locally:

1. Clone the repository:
   ```bash
   git clone https://github.com/Iam-Mohamed-Ameen-TK/Nova.git
