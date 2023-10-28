//
//  OrderService.swift

//
//  Created by Gaurav Prakash | Upkeep on 10/24/23.
//


import Foundation

enum MusicServiceError: Error {
    case serverError(MusicError)
    case unknown(String = "An unknown error occurred.")
    case decodingError(String = "Error parsing server response.")
}

class MusicService {
    
    static func fetchMusics(with endpoint: Endpoint, completion: @escaping (Result<Music, MusicServiceError>)->Void) {
        guard let request = endpoint.request else { return }
        
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }
            
            if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                
                do {
                    let orderError = try JSONDecoder().decode(MusicError.self, from: data ?? Data())
                    completion(.failure(.serverError(orderError)))
                    
                } catch let err {
                    completion(.failure(.unknown()))
                    print(err.localizedDescription)
                }
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let orderData = try decoder.decode(Music.self, from: data)
                    completion(.success(orderData))
                    
                } catch let err {
                    completion(.failure(.decodingError()))
                    print(err.localizedDescription)
                }
                
            } else {
                completion(.failure(.unknown()))
            }
            
        }.resume()
    }
    
}


struct OrderStatus: Decodable {
    let status: MusicError
}

struct MusicError: Decodable {
    let errorCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
