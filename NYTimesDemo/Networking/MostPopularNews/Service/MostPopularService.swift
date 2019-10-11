//
//  MostPopularService.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/28/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation

    struct PopularNewsService {
    
        static func getMostViewdNews(of timePeriod: PopularNewsEndPoint.TimePeriod, result: @escaping (_ newsMainModel: HttpServiceResult<PopularNewsModel>)->()) {
            
            let service = HttpService<PopularNewsEndPoint, PopularNewsModel>()
            service.call(endPoint: .viewed(time: timePeriod)) { (responseResult) in
               result(responseResult)
               return
            }
        }
    }


