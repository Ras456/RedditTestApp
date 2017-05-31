//
//  FullVC.swift
//  RedditTestApp
//
//  Created by Євген Хижняк on 31.05.17.
//  Copyright © 2017 Євген Хижняк. All rights reserved.
//

import UIKit

class FullVC: UIViewController {
    var selectedPost : PostModel!
    var url: URL?
    var isGIF : Bool?
    
    @IBOutlet weak var postImageFull: UIImageView!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    @IBAction func saveImageInLibrary(_ sender: UIBarButtonItem) {
        
        UIImageWriteToSavedPhotosAlbum(postImageFull.image!, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    // MARK:- Save in Gallery
    
    func imageSaved(_ image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        self.indicatorLoading.stopAnimating()
        var title :String?
        var message :String?
        
        if (error == nil) {
            title = "Saved to Photo Library"
        } else {
            title = "Error"
            message = error?.description
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:""), style: .default){ (action) in}
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.url = URL(string: selectedPost.images[0].htmlDecoded())
        if (url!.pathExtension.lowercased() == "gif") {
            isGIF = true
        }
        
        if isGIF != true {
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error == nil {
                    if data != nil {
                        self.postImageFull.contentMode = UIViewContentMode.scaleAspectFit
                        self.postImageFull.clipsToBounds = true
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FullVC.imageTapped(_:)))
                        self.postImageFull.addGestureRecognizer(tapGesture)
                        self.postImageFull.isUserInteractionEnabled = true
                        
                        DispatchQueue.main.async {
                            self.postImageFull.image = UIImage(data: data!)
                            self.indicatorLoading.stopAnimating()
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: NSLocalizedString("ERROR",comment:""), message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let goBackAction = UIAlertAction(title: NSLocalizedString("GO_BACK",comment:""), style: .default) { (action) in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    alertController.addAction(goBackAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }) .resume()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if isGIF == true {
            if (UIApplication.shared.openURL(url!) == false) {
                let alertController = UIAlertController(title: NSLocalizedString("ERROR",comment:""), message: NSLocalizedString("ERROR_OPENING_GIF",comment:""), preferredStyle: .alert)
                let goBackAction = UIAlertAction(title: NSLocalizedString("OK",comment:""), style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(goBackAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.dismiss(animated: false, completion: nil)
            }
            
        }
    }
    
    // MARK:- ImageTap
    
    func imageTapped(_ gesture: UIGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            let alertController = UIAlertController(title: NSLocalizedString("WHAT_TO_DO",comment:""), message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",comment:""), style: .cancel) { (action) in
                // do nothing...
            }
            let goBackAction = UIAlertAction(title: NSLocalizedString("GO_BACK",comment:""), style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let saveInGalleryAction = UIAlertAction(title: NSLocalizedString("GALLERY_SAVE",comment:""), style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                self.indicatorLoading.startAnimating()
                UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(goBackAction)
            alertController.addAction(saveInGalleryAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

extension String {
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
}
