//
//  TunesPresenter.swift
//  MailTask
//
//  Created by Ума Мирзоева on 07.11.2021.
//

import Foundation


class TunesPresenter {
    
    private let networkService: Networking
    
    private var music: [ItunesItem] = []
    private var movies: [ItunesItem] = []
    private var error: Error?
    
    init(networkService: Networking) {
        self.networkService = networkService
    }
    
    func loadData(completion: @escaping (Result<TableViewData, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        networkService.fetch(route: .music) { [weak self] result in
            switch result {
            case .success(let data):
                if let result = try? JSONDecoder().decode(ItunesResponse.self, from: data) {
                    self?.music = result.results ?? []
                }
            case .failure(let error):
                self?.error = error
            }
            dispatchGroup.leave()

        }
        dispatchGroup.enter()
        networkService.fetch(route: .movies) { [weak self] result in
            
            switch result {
            case .success(let data):
                if let result = try? JSONDecoder().decode(ItunesResponse.self, from: data) {
                    self?.movies = result.results ?? []
                }
            case .failure(let error):
                self?.error = error
                
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if let error = self.error {
                completion(.failure(error))
            } else {
                completion(.success(TableViewData(movies: self.movies, music: self.music)))
            }
        }
    }
}
