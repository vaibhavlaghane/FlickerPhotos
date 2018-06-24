//
//  ImageDownloader.swift
 
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import UIKit

class ImageDownloader: Operation {
    
    private var   photo: Photo
    private var  imageData: Data? = nil
    
    init(photo: Photo) {
        self.photo  = photo
    }
    
    override func main() {
        if self.isCancelled   {
            return
        }
        if let imgURL = self.photo.imageURL{
            imageData =   try? Data(contentsOf: imgURL)
            if(imageData != nil ){
                if let id =  self.photo.id , let image = imageData {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: receivedImageNotification), object: nil, userInfo: ["image":image  as Any   , "id":  id as String   ])
                }else{
                    if let id =  self.photo.id {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: failedImageNotification), object: nil, userInfo: ["id":  id as String   ])
                    }
                }
            }
        }else{
            photo.isImageDownloaded = .failed
            return
        }
        if imageData != nil {
            self.photo.imageData = UIImage(data:imageData!)
            self.photo.isImageDownloaded = .downloaded
            if let id = photo.id{
                _ = Utility.storeFile(id, imageData!)
            }
        }
        else
        {
            self.photo.isImageDownloaded = .failed
            self.photo.imageData = UIImage(named: "Failed")
        }
    }
    
}
