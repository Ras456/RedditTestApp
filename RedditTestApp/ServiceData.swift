//
//  Backend.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 29.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import Foundation
import UIKit


open class ServiceData : NSObject {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?

    static let sharedInstance = ServiceData()
    
    //MARK:- Parse
    
    func downloadPostToFeed(_ responseData:Data?) throws ->  [PostModel] {
        var postArray = [PostModel]()
        var nameUser, authorPost, titlePost, thumbnailURLPost, imagePost: String!
        var countCommentsPost: Int!
        var createdPost: Date!
        do {
            let json = try JSONSerialization.jsonObject(with: responseData!, options:JSONSerialization.ReadingOptions(rawValue:0)) as! [String:Any]
            if let data = json["data"] as? [String: Any] {
                if let children = data["children"] as? [[String: Any]], children.count > 0 {
                    for i in 0..<children.count {
                        if let dataPost = children[i]["data"] as? [String: Any] {
                            if let name = dataPost["name"] as? String {
                                nameUser = name
                            }
                            if let author = dataPost["author"] as? String {
                                authorPost = author
                            }
                            if let title = dataPost["title"] as? String {
                                titlePost = title
                            }
                            if let created = dataPost["created"] as? TimeInterval {
                                createdPost = Date(timeIntervalSince1970: created)
                            }
                            if let countComments = dataPost["num_comments"] as? Int {
                                countCommentsPost = countComments
                            }
                            if let thumbnailURL = dataPost["thumbnail"] as? String {
                                thumbnailURLPost = thumbnailURL
                            }
                            
                            if let imageGif = dataPost["url"] as? String {
                                imagePost = imageGif
                            }
                            
                            //                            if let preview = dataPost["preview"] as? [[String: Any]], preview.count > 0 {
                            //                                for i in 0..<preview.count {
                            //                                    if let source = preview[i]["source"] as? [String: Any] {
                            //                                        if let image = source["url"] as? String {
                            //                                            imagePost = image
                            //                                        }
                            //                                    }
                            //                                }
                            //                            }
                        }
                        let post = PostModel(name: nameUser, auth: authorPost, created: createdPost, countComments: countCommentsPost, thumbnailURL: thumbnailURLPost, title: titlePost, imageUrl: [imagePost])
                        postArray.append(post)
                    }
                }
            }
            return postArray
        }
    }


    open func getTopPost(noItems: Int, completion: @escaping (_ posts: [PostModel]?, _ error: NSError?) -> Void) -> Void  {
        sortingTopPosts(limit: noItems){(returnedData: Data?, error: NSError?) -> () in
            if (error == nil) {
                var postArray = [PostModel]()
                postArray = try! self.downloadPostToFeed(returnedData)
                completion(postArray, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func sortingTopPosts(limit:Int?, completion: @escaping (_ result: Data?, _ error: NSError?) -> Void)  {
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var urlStr = DEFAULT_URL_TOP_REDDIT
       
        if (limit != nil) {
            urlStr = urlStr + "&limit=\(limit!)"
        }
      
        let url = URL(string:urlStr)
        
        dataTask = defaultSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            if let error = error {
                completion(nil, error as NSError)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(data, nil)
                }
            }
        })
        dataTask?.resume()
    }
}

