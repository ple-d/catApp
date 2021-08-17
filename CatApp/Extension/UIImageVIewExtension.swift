//
//  UIImageVIewExtension.swift
//  CatApp
//
//  Created by XO on 12.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageWithCache (from imageURL:String, completion: @escaping (Data, String) -> Void) {
        guard let url = URL(string: imageURL) else { return }
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response else {
                    return
                }
                
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
                completion(data, imageURL)
            }.resume()
        }
    }
}
