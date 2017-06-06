//
//  PostCell.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 31.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import UIKit

open class PostCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postCreatedLabel: UILabel!
    @IBOutlet weak var postCountCommentsLabel: UILabel!
    
    var imageCache = [String:Data]()
    
    func configureCell(_ post: PostModel) {
        
        postTitleLabel.text = post.title
        postAuthorLabel.text = post.author
        postCreatedLabel.text = Utils.dateFormatted(date: post.created)
        postCountCommentsLabel.text = "\(post.countComments!) comments"
        
        URLSession.shared.dataTask(with: URL(string: post.thumbnailURL!)!, completionHandler: { (data, response, error) in
            if error == nil {
                    self.imageCache.updateValue(data!, forKey: post.thumbnailURL!)
                    DispatchQueue.main.async {
                        self.postImageView.image = UIImage(data: data!)
                        self.postImageView.isHidden = false
                    }
            } else {
                self.postImageView!.image = nil
            }
        }) .resume()
    }
}

