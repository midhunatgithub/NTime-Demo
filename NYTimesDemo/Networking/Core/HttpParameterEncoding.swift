//
//  HttpParameterEncoding.swift
//  NYTimesDemo
//
//  Created by Midhun P. Mathew on 26/08/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation

 enum HttpParameterEncoder {
    
    case url
    case json
    case urlAndJson
    
     func encode(urlRequest: inout URLRequest,
                       urlParameters: HttpParameters?,
                       bodyParameters: HttpParameters?) throws {
        do {
            switch self {
            case .url:
                guard let urlParameters = urlParameters else { return }
                try HttpUrlParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .json:
                guard let bodyParameters = bodyParameters else { return }
                try HttpJsonParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJson:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try HttpUrlParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try HttpJsonParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            }
        }catch {
            throw error
        }
    }
}

struct HttpUrlParameterEncoder: HttpParameterEncoding {
    
     func encode(urlRequest: inout URLRequest, with parameters: HttpParameters) throws {
        
        guard let url = urlRequest.url else {
            throw HttpProcessError.invalidUrl
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)))
            }
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-from-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

struct HttpJsonParameterEncoder: HttpParameterEncoding {
    
    
     func encode(urlRequest: inout URLRequest, with parameters: HttpParameters) throws {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch let error  {
            print("error = \(error)")
            throw HttpProcessError.jsonDecodingFailed
        }
    }
}
