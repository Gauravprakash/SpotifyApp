//
//  MusicResponse.swift
//  SpotifyApp
//
//  Created by Gaurav Prakash on 27/10/23.
//

import Foundation

struct MusicElement: Codable{
    let title, artist, album, url: String
}

typealias Music = [MusicElement]


