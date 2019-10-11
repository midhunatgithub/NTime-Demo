//
//  HttpService.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/29/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation


struct HttpService <E: HttpEndPoint, R: Decodable>  {
    
    enum ResponseStatus<String> {
        case success
        case failure(String)
    }

    private let requester: HttpRequester<E>
    
    init() {
        requester = HttpRequester<E>()
    }
    
    func call(endPoint: E, completion: @escaping (_ result: HttpServiceResult<R>)->())  {
        
        requester.request(to: endPoint) { (data, response, error) in
            guard error == nil else {
                completion(HttpServiceResult.failure(.connectionFailed))
                return
            }
            guard let response = response as?  HTTPURLResponse else {
                completion(HttpServiceResult.failure(.noResponse))
                return
            }
            let status = self.getResposeStatus(response)
            switch status {
                
            case .success:
                guard let data = data else {
                   completion(HttpServiceResult.failure(.noData))
                   return
                }
                
                do {
                    print(data)
//                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//                    print(jsonData)
                    let model = try JSONDecoder().decode(R.self, from: data)
                    completion(HttpServiceResult.success(model))
                    //completion(apiResponse.movies,nil)
                } catch {
                    print(error)
                    // completion(nil, NetworkResponse.unableToDecode.rawValue)
                    completion(HttpServiceResult.failure(.jsonDecodingFailed))
                }
                
            case .failure(_):
                break
          
            }
            
        }
    }
    
    
    
   private func getResposeStatus(_ response: HTTPURLResponse) -> ResponseStatus<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(HttpResponseStatus.authenticationError.rawValue)
        case 501...599: return .failure(HttpResponseStatus.badRequest.rawValue)
        case 600: return .failure(HttpResponseStatus.outdated.rawValue)
        default: return .failure(HttpResponseStatus.failed.rawValue)
        }
    }
}
