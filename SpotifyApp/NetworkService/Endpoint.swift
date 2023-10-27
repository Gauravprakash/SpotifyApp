//
//  Endpoint.swift
//  Upkeep iOS Interview Project
//
//  Created by Gaurav Prakash | Upkeep on 10/24/23.
//


import Foundation

enum Endpoint {
    
    case fetchMusic(url: String = "https://www.jsonkeeper.com/b/C47J")
    
    var request: URLRequest? {
        guard let url = URL(string: ApiEndpoints.musicUrl) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        return request
    }
    
    private var path: String {
        switch self {
        case .fetchMusic(let url):
            return url
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .fetchMusic:
            return [URLQueryItem]()
        }
    }
    
    
    private var httpMethod: String {
        switch self {
        case .fetchMusic:
            return HTTP.Method.get.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .fetchMusic:
            return nil
        }
    }
}
