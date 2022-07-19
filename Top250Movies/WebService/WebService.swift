//
//  WebService.swift
//  Top250Movies
//
//  Created by admin on 18.07.2022.
//

import Foundation


enum RequestUrl: String {
    typealias RawValue = String
    
    case top250Movies = "/Top250Movies"
}


class WebService {
    
    let api = "https://imdb-api.com/en/API"
    let apiKey = "/k_2xdwfc4d"
    
    
    func getMovies(requestUrl: RequestUrl!, completionHandler: @escaping ([TopMovies]) -> Void) {
        let url = URL(string: api + requestUrl.rawValue + apiKey)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let topMovies = try decoder.decode(Data.self, from: data)
                completionHandler(topMovies.items)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
