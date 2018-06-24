//
//  PhotosViewModel.swift
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import UIKit

let photoControllerXib = "PhotoScrollViewController"
let receivedImageNotification = "ReceivedImageNotification"
let failedImageNotification = "ReceivedImageNotification"
let receivedImageSelector = "receivedImage:"

class PhotosViewModel: NSObject, PhotoSearchDelegate {
    private var window: UIWindow? = nil
    private var catalogList = [Photo]()
    private var netOp = NetworkOperationManager()
    private var pageNumber = 1;
    private let pageSize = 30 ;
    private var vc = PhotoScrollViewController()
    private var currentSearchText = ""
    
    override init() {
        super.init()
        self.loadView()
    }
    
    private func loadView(){
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        vc = PhotoScrollViewController(nibName: photoControllerXib, bundle: nil )
        //set the delegate of the scroll view... to listen to actions from the scroll view
        rootViewController?.present(vc, animated: true, completion: nil)
        vc.setDelegate(self )
    }
 
    private  func downloadData( _ text: String ){
        var newText = false
        if(text != currentSearchText){
            currentSearchText = text
            self.pageNumber = 1 //restart the page number
            newText = true
        }
        netOp.downloadData(pageNumber: self.pageNumber, pageSize: self.pageSize, searchText: text) {  (photos) in
            self.pageNumber = (self.pageNumber) + (self.pageSize)  ;
            guard let currPhotoList = photos  else {
                // error message that data is empty
                Utility.showAlertMessageVC(self.vc, "Retrieved Empty Data", withTitle: "Download Error", onClick: {
                    self.supplyDataToScrollView([], newText )
                })
                return
            }
            if(currPhotoList.count != 0){
                self.supplyDataToScrollView(currPhotoList, newText )
            }else{
                Utility.showAlertMessageVC(self.vc ,"Retrieved Empty Data", withTitle: "Download Error", onClick: {
                    self.supplyDataToScrollView([], newText )
                })
            }
        }
    }
    
    private func supplyDataToScrollView(_ currPhotoList: [Photo], _ isNewtText: Bool ){
        var table1P = [Photo]()
        var table2P = [Photo]()
        var table3P = [Photo]()
        var i = 0
        while (i  < currPhotoList.count ){
            table1P.append(currPhotoList[i])
            i = i + 1
            if(i < currPhotoList.count){
            table2P.append(currPhotoList[i])
            }else {break }
            i = i + 1
            if(i < currPhotoList.count){
            table3P.append(currPhotoList[i])
            }else{break }
            i = i + 1
        }
        self.vc.appendData(table1P, table2P, table3P, isNewtText)
    }
    
    //MARK - searchController delegate method
    func searchPhoto(text: String) {
        if(text.count != 0){
            downloadData(text)
        }
    }
    
}
