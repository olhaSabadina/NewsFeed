//
//  NetworkManager.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 14.12.2023.
//

import UIKit
import Alamofire
import FeedKit

struct NetworkManager {
    
    func loadRSSFeed(urlString: String, completion: @escaping (Result<Feed,Error>) -> Void) {
        
        AF.request(urlString).response { response in
            if let error = response.error {
                completion(.failure(error))
                
            } else if let data = response.data {
               feedParser(data: data, completion: completion)
            }
        }
    }
    
    private func feedParser(data: Data, completion: @escaping (Result<Feed,Error>) -> Void) {
        FeedParser(data: data).parseAsync(queue: DispatchQueue.global(qos: .background)) { result in
            switch result {
            case .success(let feed):
                return completion(.success(feed))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
