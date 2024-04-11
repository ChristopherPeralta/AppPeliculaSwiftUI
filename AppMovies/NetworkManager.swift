//
//  NetworkManager.swift
//  AppMovies
//
//  Created by Christopher Peralta on 11/04/24.
//

import Foundation

enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case decodingError
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    static let upcoming = "https://api.themoviedb.org/3/movie/upcoming?api_key=bbf4ee605b49ebabf960545fbfbb1e0a&language=es-MX&page=1"
    
    func getLisOfUpcomingMovies(numPage: Int, completed: @escaping (Result<MovieDataModel, APError>) -> Void ) {
            guard let url = URL(string: NetworkManager.upcoming+"\(numPage)") else {
                completed(.failure(.invalidURL))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completed(.failure(.unableToComplete))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }
                
                do {
                   let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(MovieDataModel.self, from: data)
                    completed(.success(decodedResponse))
                } catch {
                    print("Debug: error \(error.localizedDescription)")
                    completed(.failure(.decodingError))
                }
            }
            task.resume()
        }
    }

