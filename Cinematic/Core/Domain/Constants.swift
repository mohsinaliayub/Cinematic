//
//  Constants.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

struct Constants {
    struct APIConstants {
        /// Cinematic API Key (v3).
        static let apiKey = "PUT YOUR API KEY HERE"
        /// Base URL for all the queries against The Movie DB API, except for images.
        static let baseURL = "https://api.themoviedb.org/3"
        /// Base URL for image requests.
        static let baseURLForImages = "https://image.tmdb.org/t/p/original"
    }
}
