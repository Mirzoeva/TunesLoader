//
//  Network.swift
//  MailTask
//
//  Created by Ума Мирзоева on 04.11.2021.
//

import Foundation

enum Route {
    case movies
    case music
    
    func path() -> String {
        switch self {
        case .movies:
            return "&media=movie&term=RyanGosling"
        case .music:
            return "&media=music&term=RyanGosling"
        }
    }
}

protocol Networking {
    func fetch(route: Route, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkingImpl: Networking {
    
    let baseUrl = "https://itunes.apple.com/search?country=RU"
    let session = URLSession.shared
    
    func fetch(route: Route, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl.appending(route.path())) else { return }
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        .resume()
        
    }
}
