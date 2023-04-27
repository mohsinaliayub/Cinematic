//
//  Constants.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import UIKit

enum Constants {
    enum APIConstants {
        /// Cinematic API Key (v3).
        static let apiKey = "185baa4f934e339d55802566a3dbaf27"
        /// Base URL for all the queries against The Movie DB API, except for images.
        static let baseURL = "https://api.themoviedb.org/3"
        /// Base URL for image requests.
        static let baseURLForImages = "https://image.tmdb.org/t/p/original"
    }
    
    enum Colors {
        static let backgroundColor = UIColor(named: "background-color")!
    }
}
