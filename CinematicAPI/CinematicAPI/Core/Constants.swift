//
//  Constants.swift
//  CinematicAPI
//
//  Created by Mohsin Ali Ayub on 12.05.23.
//

import UIKit

public enum Constants {
    public enum APIConstants {
        /// Cinematic API Key (v3).
        public static let apiKey = ""
        /// Base URL for all the queries against The Movie DB API, except for images.
        public static let baseURL = "https://api.themoviedb.org/3"
        /// Base URL for image requests.
        public static let baseURLForImages = "https://image.tmdb.org/t/p/original"
    }
    
    enum Colors {
        static let backgroundColor = UIColor(named: "background-color")!
    }
}
