//
//  HomeSceneViewModel.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/30/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation


protocol HomeSceneViewModelDelegate: class {
    func tableViewReloadingNeeded()
}

class HomeSceneViewModel {
    
    weak var delegate: HomeSceneViewModelDelegate?

    enum ListOperations {
        
        case append(newNewsList: [NewsCellViewModel])
        
        case create(newsList: [NewsCellViewModel])
    }
    
    let model = HomeSceneModel()
    
    var newsList = [NewsCellViewModel]()
    
    func populateNews(ofTimePeriod timePeriod: PopularNewsEndPoint.TimePeriod) {
        
        model.getMostViewedNews(of: timePeriod) { (newsList) in
            let newsViewModelList =  newsList.map({ (news) -> NewsCellViewModel in
                return NewsCellViewModel(with: news)
            })
            self.doListOperations(operation: .create(newsList: newsViewModelList))
        }
       
    }
  
    private  func doListOperations(operation: ListOperations) {
        
        switch operation {
    
        case .append(let newNewsList):
            self.newsList.append(contentsOf: newNewsList)
        case .create(let newsList):
            self.newsList = []
            self.newsList.append(contentsOf: newsList)
       
        }
        delegate?.tableViewReloadingNeeded()
    }
    
    func configure(cell: NewsTableViewCell, atIndexPath indexPath: IndexPath) {
        cell.configure(withModel: newsList[indexPath.row])
    }
    
    func timePeriodSegmentDidSelected(atIndex index: Int) {
        let timePeriod: PopularNewsEndPoint.TimePeriod
        switch index {
        case 0:
            timePeriod = PopularNewsEndPoint.TimePeriod.lastDay
        case 1:
            timePeriod = PopularNewsEndPoint.TimePeriod.lastWeek
        case 2:
            timePeriod = PopularNewsEndPoint.TimePeriod.lastMonth
        default:
            timePeriod = PopularNewsEndPoint.TimePeriod.lastDay
        }
        self.populateNews(ofTimePeriod: timePeriod)
    }
}

protocol NewsCellCompactable {
    
    var heading: String{get set}
    var abstract: String{get set}
    var date: String{get set}
    var author: String{get set}
}

struct NewsCellViewModel: NewsCellCompactable {
    
    var heading: String
    
    var abstract: String
    
    var date: String
    
    var author: String
    
    
    init(with newsModel: NewsModel) {
        
        heading = newsModel.title
        abstract = newsModel.abstract
        author = newsModel.byline
        date = newsModel.date
    }
    
}
