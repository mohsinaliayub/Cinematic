//
//  ImageDownloader.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 25.04.23.
//

import UIKit

protocol ImageDownloader {
    func downloadImage(from url: URL) async throws -> UIImage?
}

struct CinematicImageDownloader: ImageDownloader {
    
    func downloadImage(from url: URL) async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let error = NetworkRequestError.networkError(from: response as? HTTPURLResponse) {
            throw error
        }
        
        return UIImage(data: data)
    }
}
