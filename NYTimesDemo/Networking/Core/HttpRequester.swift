//
//  HttpRequester.swift
//  NYTimesDemo
//
//  Created by Midhun P. Mathew on 27/08/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation



class HttpRequester<EndPoint: HttpEndPoint>: HttpRequestable {
   
    private var task: URLSessionTask?
    
    func request(to endPoint: EndPoint, result: HttpRequestResultClosure?) {
        
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: endPoint)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                result?(data, response, error)
            })
        }catch {
            result?(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        
    }

}
extension HttpRequester {
    
    fileprivate func buildRequest(from endPoint: EndPoint) throws -> URLRequest {
        
        let url = endPoint.baseUrl.appendingPathComponent(endPoint.path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.method.name
        do {
            switch endPoint.task {

            
            case .request:
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestWithParams(let urlParameters, let bodyParameters, let encoder):
                try performEncoding(withParams: urlParameters, and: bodyParameters, withEncoder: encoder, for: &request)
            case .requestWithParamsAndHeader(let urlParameters, let bodyParameters, let header, let encoder):
               try performEncoding(withParams: urlParameters, and: bodyParameters, withEncoder: encoder, for: &request)
               addAdditionalHeaders(header, request: &request)
           
            return request
            }
        } catch {
            throw error
        }
        return request
    }
    
    fileprivate func performEncoding(withParams  urlParameters: HttpParameters?,
                                     and bodyParameters: HttpParameters?,
                                      withEncoder encoder: HttpParameterEncoder,
                
                                      for request: inout URLRequest) throws {
        do {
            try encoder.encode(urlRequest: &request,
                               urlParameters: urlParameters, bodyParameters: bodyParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HttpHeader?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
