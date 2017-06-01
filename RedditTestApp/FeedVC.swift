//
//  FeedColl.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 31.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentPosts = [PostModel]()
    var imageCache = [String:Data]()
    var refreshControl: UIRefreshControl!
    let limit = limitTopPosts
    var isLoadingNextPosts:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Top \(limit) posts"
        automaticallyAdjustsScrollViewInsets = false
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self,
                                 action: #selector(FeedVC.refresh(_:)),
                                 for:UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        
        getPosts()
    }
    
    func displayLoading() {
        DispatchQueue.main.async {
            self.isLoadingNextPosts = true
            self.collectionView.reloadData()
        }
    }
    func hideLoading() {
        DispatchQueue.main.async {
            self.isLoadingNextPosts = false
            self.collectionView.reloadData()
        }
    }
    func refresh(_ sender:AnyObject) {
        self.refreshControl?.beginRefreshing()
        collectionView.reloadData()
        self.refreshControl?.endRefreshing()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.collectionViewLayout.invalidateLayout()
        hideLoading()
    }
    
    // MARK:- GET POSTS
    
    func getPosts() {
        self.displayLoading()
        ServiceData.sharedInstance.getTopPost(noItems:limit){(posts: [PostModel]?, error: NSError?) -> () in
            if (error == nil) {
                if (!posts!.isEmpty) {
                    self.currentPosts = posts! + self.currentPosts
                }
                DispatchQueue.main.async {
                    self.isLoadingNextPosts = false
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    // MARK:- SEGUE
    
    func imageTapped(_ gesture: UIGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            let row = imageView.tag
            performSegue(withIdentifier: "displayFullScreenImageSegue", sender: row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "displayFullScreenImageSegue") {
            let vc: FullVC = segue.destination as! FullVC
            vc.selectedPost = self.currentPosts[sender as! Int]
        }
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.currentPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCellIdentifier",for:indexPath) as! PostCell
        let post = self.currentPosts[indexPath.row]
        cell.configureCell(post)
        cell.postImageView.tag = indexPath.row
        
        cell.postImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FeedVC.imageTapped(_:)))
        cell.postImageView.addGestureRecognizer(tapGesture)
        cell.postImageView.isUserInteractionEnabled = true
        cell.postImageView.tag = indexPath.row
        cell.postImageView.isHidden = true
        
        if (post.thumbnailURL != nil && post.thumbnailURL! != "" && post.thumbnailURL! != "self" && post.thumbnailURL! != "default") {
            if (imageCache[post.thumbnailURL!] == nil) {
                
                URLSession.shared.dataTask(with: URL(string: post.thumbnailURL!)!, completionHandler: { (data, response, error) in
                    if error == nil {
                        if let cellToUpdate = self.collectionView?.cellForItem(at: indexPath) as? PostCell {
                            self.imageCache.updateValue(data!, forKey: post.thumbnailURL!)
                            DispatchQueue.main.async {
                                cellToUpdate.postImageView.image = UIImage(data: data!)
                                cellToUpdate.postImageView.isHidden = false
                                cellToUpdate.setNeedsLayout()
                                cellToUpdate.layoutIfNeeded()
                            }
                        }
                    } else {
                        cell.postImageView!.image = nil
                    }
                }) .resume()
            } else {
                cell.postImageView!.image = UIImage(data: imageCache[post.thumbnailURL!]!)
                cell.postImageView.isHidden = false
                cell.postImageView.setNeedsLayout()
                cell.postImageView.layoutIfNeeded()
            }
        } else {
            cell.postImageView!.image = nil
        }
        cell.layer.borderWidth = 1
        return cell
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            // portrait
            return CGSize(width: (UIScreen.main.bounds.width),height: UIScreen.main.bounds.height/6);
        } else {
            // landscape
            return CGSize(width: (UIScreen.main.bounds.width-2)/3,height: UIScreen.main.bounds.height/3);
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

