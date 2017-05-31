//
//  PostCell.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 31.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postCreatedLabel: UILabel!
    @IBOutlet weak var postCountCommentsLabel: UILabel!
    
    
    func configureCell(_ post: PostModel) {
        postTitleLabel.text = post.title
        postAuthorLabel.text = post.author
        postCreatedLabel.text = Utils.dateFormatted(date: post.created)
        postCountCommentsLabel.text = "\(post.countComments!) comments"
    }

}
