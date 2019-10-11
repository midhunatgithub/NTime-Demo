//
//  PopularNewsModel.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/29/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import Foundation

struct PopularNewsModel: Decodable {
    
    let status: String
    let copyright: String
    let count: Int
    let results: [NewsModel]
}
extension PopularNewsModel{
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case count = "num_results"
        case results
    }
}


struct NewsModel: Decodable {
    
    let url: String
    let section: String
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let source: String
    let date: String
    let id: UInt64
    let assetId: UInt64
    let views: UInt64
    let media: [MediaModel]
    
}
extension NewsModel{
    enum CodingKeys: String, CodingKey {
        case url
        case section
        case byline
        case type
        case title
        case abstract
        case source
        case date = "published_date"
        case id
        case assetId = "asset_id"
        case views
        case media
    }
}


struct MediaModel: Decodable {
    
    let type: String
    let subtype: String
    let caption: String?
    let copyright: String?
    let metaData: [MetaDataModel]
   
}
extension MediaModel{
    enum CodingKeys: String, CodingKey {
        case type
        case subtype
        case caption
        case copyright
        case metaData = "media-metadata"
    }
}


struct MetaDataModel: Decodable {
    
    let url: String
    let format: String
    let height: Float
    let width: Float
}
