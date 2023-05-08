# Cinematic
Cinematic lets you browse trending movies and TV shows from the popular [The Movie Database](https://www.themoviedb.org/).

# Description
Cinematic is a simple browsing application.
- It uses the modern async/await syntax to download data from [TMDB API](https://www.themoviedb.org/settings/api).
- It uses [SDWebImage](https://github.com/SDWebImage/SDWebImage) to load images asynchronously.
- You can search for your favorite movies, TV Shows and actors/actresses.
- You can set up filters to fine-grain your search.

# Set Up
To use this app, you will need to obtain an API key from [TMDB API](https://www.themoviedb.org/settings/api).

After obtaining the **API key**, go to [Constants.swift](/Cinematic/Core/Domain/Constants.swift) and paste the API key in **apiKey** property.

```swift
enum Constants {
  enum APIConstants {
    /// Cinematic API Key (v3).
    static let apiKey = "PUT YOUR API KEY HERE"
    // removed for brevity
  }
}

```

# Progress
The progress history of tasks being performed for the application:
- [x] Download trending movies and TV shows.
- [x] Use compositional layout to display the items
- [ ] Show the detail for selected movie and tv show
- [ ] Provide search option to search and filter the movies and tv shows.
- [ ] Add animations and transitions.

# Screenshots
<img src="/Screenshots/Home.png" width="231" height="500" alt="Home">

