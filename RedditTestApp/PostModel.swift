//
//  PostModel.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 26.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import Foundation

open class PostModel {
    var name: String!
    var author: String!
    var created: Date!
    var title: String!
    var thumbnailURL: String!
    var thumbnailData: Data!
    var countComments: Int!
    var images = [String]()
    
    init(name: String!, auth: String!, created: Date!, countComments: Int!, thumbnailURL: String!, title: String!, imageUrl: [String]!) {
        self.author = auth
        self.countComments = countComments
        self.created = created
        self.name = name
        self.thumbnailURL = thumbnailURL
        self.images = imageUrl
        self.title = title
    }
}
