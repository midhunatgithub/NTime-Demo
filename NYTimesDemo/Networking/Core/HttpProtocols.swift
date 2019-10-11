//
//  NetworkLayer.swift
//  NYTimesDemo
//
//  Created by Midhun P. Mathew on 26/08/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation

typealias HttpHeader = [String: String]

typealias HttpParameters = [String: Any]

typealias HttpRequestResultClosure = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()

protocol HttpParameterEncoding {
    
     func encode(urlRequest: inout URLRequest, with parameters: HttpParameters) throws
}

enum HttpResponseStatus: String {
    
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}



enum HttpProcessError: String, Error {
    
    case invalidUrl = "error"
    case connectionFailed = "Internet Connection Error"
    case noResponse = "Connection completed without a response"
    case noData = "Connection completed without a data"
    case jsonDecodingFailed = "Json decoder faild to decode into specific model"
}

enum HttpMethod: String {
    
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
    
    var name: String {
        return self.rawValue
    }
}

enum HttpTask {
    
    case request
    case requestWithParams(urlParameters: HttpParameters?, bodyParameters: HttpParameters?, encoder: HttpParameterEncoder)
    case requestWithParamsAndHeader(urlParameters: HttpParameters?, bodyParameters: HttpParameters?, header: HttpHeader?, encoder: HttpParameterEncoder)
}

protocol HttpEndPoint {
    
    var baseUrl: URL {get }
    var path: String {get }
    var method: HttpMethod {get }
    var header: HttpHeader? {get }
    var task: HttpTask {get }
}

protocol HttpRequestable: class {
    
    associatedtype EndPoint
    func request(to endPoint: EndPoint, result: HttpRequestResultClosure?)
    func cancel()
}

enum HttpServiceResult<T: Decodable> {
    case success(T)
    case failure(HttpProcessError)
}

struct NYEndPoint {
    
}
struct NYService {
    
}
