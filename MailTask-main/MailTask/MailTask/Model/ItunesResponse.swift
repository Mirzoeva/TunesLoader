//
//  Movie.swift
//  MailTask
//
//  Created by Ума Мирзоева on 04.11.2021.
//

import Foundation

struct ItunesResponse: Codable {
    let resultCount: Int?
    let results: [ItunesItem]?
}

struct ItunesItem: Codable {
    let trackId: Int?
    let trackName: String?
    let artworkUrl100: String?
}
