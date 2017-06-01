//
//  Constants.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 30.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import Foundation

typealias ComleationToGetPosts = (_ posts: [PostModel]?, _ error: NSError?) -> Void
typealias CompletionToLimitPosts = (_ result: Data?, _ error: NSError?) -> Void

let DEFAULT_URL_TOP_REDDIT = "https://www.reddit.com/top/.json?"

let limitTopPosts = 50
