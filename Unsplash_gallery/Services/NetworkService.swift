//
//  NetworkService.swift
//  Unsplash_gallery
//
//  Created by Никита Рыльский on 30.06.2022.
//

import Foundation

enum ServiceError: Error {
    case urlError
    case serverError
    case notData
    case decodeError
}

class NetworkService {
    
    private var session: URLSession
    private var components = URLComponents()
    private var key = "QO3zmfFNKo_pyUeVdX2AonsUVlRBYL66ck-zH3-fSkI"
    private let count = 30
    
    init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
        components.scheme = "https"
        components.host = "api.unsplash.com"
    }
    
    private func getURL(path: String, params: [String:String]) -> URL? {
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url
    }
    
    func getRandomPhotos(completion: @escaping (Result<[PhotoModel], ServiceError>) -> Void) {
        let path = "/photos/random"
        let parameters: [String:String] = ["count": "\(count)", "client_id": "\(key)"]
        guard let url = getURL(path: path, params: parameters) else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError))
                debugPrint(String(describing: error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.notData))
                debugPrint(String(describing: error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([PhotoModel].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeError))
                debugPrint("Failed to decode...")
            }
        }
        
        task.resume()
    }
    
    func getSearchPhotos(query: String, completion: @escaping (Result<[PhotoModel], ServiceError>) -> Void) {
        let path = "/search/photos"
        let parameters: [String:String] = ["query": "\(query)", "client_id": "\(key)"]
        guard let url = getURL(path: path, params: parameters) else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError))
                debugPrint(String(describing: error))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.notData))
                debugPrint(String(describing: error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PhotosResponseModel.self, from: data)
                completion(.success(result.results ?? []))
            } catch {
                completion(.failure(.decodeError))
                debugPrint("Failed to decode...")
            }
        }
        
        task.resume()
    }
}
