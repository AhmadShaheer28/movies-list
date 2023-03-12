//
//  Extensions.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import UIKit


class ImageCache {
    private init() {}
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getImage(from url: URL) {
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            print("Image from cache")
            self.image = cachedImage
        }
        
        downloadImage(from: url) { (data, response, error) in
            if let _ = error {
                self.image = nil
            } else if let imgData = data, let image = UIImage(data: imgData) {
                ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
                print("Image from cache")
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
