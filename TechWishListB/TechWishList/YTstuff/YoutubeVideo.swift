//
//  YoutubeVideo.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
struct YoutubeVideo {
    let title: String
    let videoId: String
    let description: String
    let defaultQualityThumbnailUrl: String
    let highQualityThumbnailUrl: String
    init(title: String, videoId: String, description: String, defaultQualityThumbnailUrl: String, highQualityThumbnailUrl: String) {
        self.title = title
        self.videoId = videoId
        self.description = description
        self.defaultQualityThumbnailUrl = defaultQualityThumbnailUrl
        self.highQualityThumbnailUrl = highQualityThumbnailUrl
    }
}
