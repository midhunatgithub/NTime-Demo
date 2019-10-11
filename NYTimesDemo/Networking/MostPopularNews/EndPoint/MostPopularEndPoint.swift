//
//  MostPopularEndPoint.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/28/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation


    enum PopularNewsEndPoint {
        
        
        enum TimePeriod: Int {
            case lastDay = 1
            case lastWeek = 7
            case lastMonth = 30
            
            var path: String {
                return "/\(self.rawValue).json"
            }
        }
        
        case emailed(time: TimePeriod)
        case shared(time: TimePeriod)
        case viewed(time: TimePeriod)
    }


    

    

extension PopularNewsEndPoint:  HttpEndPoint {
    var baseUrl: URL {
        guard let url = URL(string: "https://api.nytimes.com/svc") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        
        switch self {
            
        case .emailed(let time):
            return "/mostpopular/v2/emailed" + time.path
        case .shared(let time):
            return "/mostpopular/v2/shared" + "/\(time.rawValue)/facebook.json)"
        case .viewed(let time):
            return "/mostpopular/v2/viewed" + time.path
            
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var header: HttpHeader? {
        return nil
    }
    
    var task: HttpTask {
        return .requestWithParams(urlParameters: ["api-key":"Nn1GyHkLog8qHcN4CzMU1BmynHAqQw83"], bodyParameters: nil, encoder: HttpParameterEncoder.url)
    }
}
