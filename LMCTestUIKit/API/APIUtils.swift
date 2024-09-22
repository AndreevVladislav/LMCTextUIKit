//
//  APIUtils.swift
//  LMCTestUIKit
//
//  Created by Vladislav Andreev on 21.09.2024.
//

import Foundation
import UIKit

class APIUtils {
    
    /// Показ алерта
    static func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Запрос на получение списка фильмов по фильтрам
    func getMovies_WithFilter(yearFrom: Int, yearTo: Int, keyword: String, page: Int, apiKey: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let urlString = "\(Constants.API.baseURL)/api/v2.2/films?order=RATING&type=FILM&yearFrom=\(yearFrom)&yearTo=\(yearTo)&keyword=\(keyword)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(GenericResponse<MovieModel>.self, from: data)
                completion(.success(movieResponse.items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    /// Запрос на получение популярных фильмов (для отобажения при ходе в приложение)
    func getMovies_Popular(apiKey: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let urlString = "\(Constants.API.baseURL)/api/v2.2/films/collections?type=TOP_POPULAR_ALL&page=1"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(GenericResponse<MovieModel>.self, from: data)
                completion(.success(movieResponse.items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    /// Запрос на получение информации о фильме по ID
    func getMovie_Info(movieId: Int, apiKey: String, completion: @escaping (Result<MovieInfoModel, Error>) -> Void) {
        let urlString = "\(Constants.API.baseURL)/api/v2.2/films/\(movieId)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusError = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(.failure(statusError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movieDetails = try JSONDecoder().decode(MovieInfoModel.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    /// Запрос на получение кадров из фильма по ID
    func getMovies_Frame(movieId: Int, apiKey: String, completion: @escaping (Result<[FrameModel], Error>) -> Void) {
        let urlString = "\(Constants.API.baseURL)/api/v2.2/films/\(movieId)/images?type=STILL&page=1"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(GenericResponse<FrameModel>.self, from: data)
                completion(.success(movieResponse.items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
