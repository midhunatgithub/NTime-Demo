//
//  HomeSceneDataModel.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/30/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation

struct HomeSceneModel {
    
    
    func getMostViewedNews(of timePeriod: PopularNewsEndPoint.TimePeriod ,result: @escaping (_ news: [NewsModel]) -> ()) {
        PopularNewsService.getMostViewdNews(of: timePeriod) { (resultModel) in
            switch resultModel {
                
            case .success(let newsModel):
              result(newsModel.results)
              return
            case .failure(_):
                return
            }
        }
    }
    
}
