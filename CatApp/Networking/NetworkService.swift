//
//  NetworkingManager.swift
//  CatApp
//
//  Created by XO on 10.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCats(completion: @escaping (Result<[Cat]?, Error>) -> Void)
}

class NetworkService {
    
    func getCats(page: Int, completion: @escaping (Result<[Cat]?, ErrorMessage>) -> Void) {
        let urlString = "https://api.thecatapi.com/v1/images/search?limit=20&page=\(page)&order=ASC"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("20801bbd-9132-4cb1-b4d4-eae3ba8fb56d", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode([Cat].self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
        
    }
}
