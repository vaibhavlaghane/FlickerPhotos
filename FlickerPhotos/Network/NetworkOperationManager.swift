//
//  NetworkOperationManager.swift
 
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import UIKit

class PendingOperations {
    lazy internal var downloadsInProgress = [Int:Operation]()
    lazy internal var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

/// network operations manager class
class NetworkOperationManager: NSObject {
 
    private let  downloader = DataDownloader()
    @objc  public dynamic private(set) var photos = [Photo]()
    private  let pendingOperations = PendingOperations()
    
    /// download JSON data for given page and size
    ///
    /// - Parameters:
    ///   - pageNumber: page number
    ///   - pageSize: size of page
    ///   - completion: completion block 
    func downloadData( pageNumber: Int,pageSize: Int, searchText: String  ,  completion: @escaping ([Photo]? ) -> Void )->Void{
        downloader.getJSONData(pageNumber: pageNumber, pageSize: pageSize, searchText:  searchText, completion: {  [weak self ] (dict) in
            let pList = Utility.parseJSON(dict: dict)
            self?.photos.append(contentsOf:pList  )
            completion(pList)
            for (index, element) in (self?.photos.enumerated())!{
                self?.startDownloadPhotoImage(photo: element, index: index)
            }
        }) { (response, error) in   //
            Utility.showAlertMessage("Failed to Download the Content", withTitle: "Download Update", onClick: {
                NSLog(error as! String)
            })
            NSLog(error as! String)
        }
    }
    
    /// start image download operation
    ///
    /// - Parameters:
    ///   - photo: photo
    ///   - index: index of photo
    func startOperationsPhoto(photo: Photo, index: Int){
        switch (photo.isImageDownloaded) {
        case .new:
            startDownloadPhotoImage(photo: photo, index: index)
        case .failed:
            startDownloadPhotoImage(photo: photo, index: index)
        default:
            NSLog("do nothing")
        }
    }
    
    /// method starts the image download operation on the OperationQueue
    ///
    /// - Parameters:
    ///   - photo: photo to download the image for
    ///   - index: index of the photo in the array
    func startDownloadPhotoImage(photo: Photo, index: Int){
        if let id = photo.id{
            if let  img =  Utility.getImageFile(id)  {
                photo.imageData = img
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: receivedImageNotification), object: nil, userInfo: ["image":img  as Any   , "id":  id as String   ])
                return
            }
        }
        if let _ = pendingOperations.downloadsInProgress[index ] {
            //download is in progress...return 
            return
        }
        let downloader = ImageDownloader(photo: photo)
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: index )
            }
        }
        pendingOperations.downloadsInProgress[index ] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
