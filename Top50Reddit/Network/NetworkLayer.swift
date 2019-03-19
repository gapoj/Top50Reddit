//
//  NetworkLayer.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
typealias ErrorHandler = (String) -> Void

class NetworkLayer {
    static let genericError = "Something went wrong. Please try again later"
    static let urlError = "Something went wrong. Please try again later"
    //I am not using headerds right now but just in case
    //Using generics so It could be reusable
    func get<T: Decodable>(urlString: String,
                           headers: [String: String] = [:],
                           successHandler: @escaping (T) -> Void,
                           errorHandler: @escaping ErrorHandler) {
        
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                errorHandler(NetworkLayer.genericError)
                return
            }
            
            if self.isSuccessCode(urlResponse) {
                guard let data = data else {
                    print("Unable to parse the response in given type \(T.self)")
                    return errorHandler(NetworkLayer.genericError)
                }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase//so I can use camel case
                if let responseObject = try? jsonDecoder.decode(T.self, from: data) {
                    successHandler(responseObject)
                    return
                }
            }
            errorHandler(NetworkLayer.genericError)
        }
        
        guard let url = URL(string: urlString) else {
            return errorHandler(NetworkLayer.urlError)
        }
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: request,
                                   completionHandler: completionHandler)
            .resume()
    }
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return (200...300).contains(statusCode)
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
}

