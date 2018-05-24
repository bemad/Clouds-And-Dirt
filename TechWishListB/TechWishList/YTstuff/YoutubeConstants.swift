//
//  YoutubeConstants.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
// Example of YouTube API search query GET request formatting
// https://www.googleapis.com/youtube/v3/search?key=AIzaSyDo7h-vPHPqz6XZPz1-LBVwvVEn9aqV29Y&type=video&q=surfing&maxResults=50&part=snippet
extension YTsearchResultsTableViewController {
    struct Constants {
        struct Youtube {
            static let APIScheme = "https"
            static let APIHost = "www.googleapis.com"
            static let APIPath = "/youtube/v3/search"
        }
        struct YoutubeParameterKeys {
            static let APIKey = "key"
            static let ResultType = "type"
            static let SearchQuery = "q"
            static let NumberOfResults = "maxResults"
            static let SearchResourceProperty = "part"
        }
        struct YoutubeParameterValues {
            //please reviewer no misue
            //my gmail account important lol
            static let APIKey = "AIzaSyDduB8CSsNVdtjiYIk2l4dUqlG87h0VVUk"
            static let ResultType = "video"
            static let NumberOfResults = "50"
            static let SearchResourceProperty = "snippet"
        }
        struct YoutubeResponseKeys {
            static let SearchResultItems = "items"
            static let ResultId = "id"
            static let VideoId = "videoId"
            static let Snippet = "snippet"
            static let VideoTitle = "title"
            static let VideoDescription = "description"
            static let VideoThumbnails = "thumbnails"
            static let DefaultQualityThumbnail = "default"
            static let HighQualityThumbnail = "high"
            static let ThumbnailUrl = "url"
        }
    }
}
