//
//  Photo.swift
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import UIKit

enum ImageDownLoadState:String  {
    case new
    case downloaded
    case inProgress
    case failed
}

class Photo: NSObject {
    public private(set) var id: String?
    public private(set) var owner: String?
    public private(set) var secret: String?
    public private(set) var server: String?
    public private(set) var farm: Int
    public private(set) var title: String?
    public private(set) var ispublic: Bool?
    public private(set) var isfriend: Bool?
    public private(set) var isfamily: Bool?
    var isImageDownloaded: ImageDownLoadState = .new
    public private(set) var index = 0
    var imageData: UIImage?
    public var imageURL: URL?  {
        get{
            var  url = "http://farm" + String(self.farm)
            url = url + ".static.flickr.com/"
            if let serv = self.server{
                url = url + serv + "/"
            }else{return nil }
            if let id = self.id{
                url = url + id  + "_"
            }else{return nil }
            if let sec = self.secret{
                url = url + sec + ".jpg"
            }else{return nil }
            return  URL.init(string: url )
        }
    }
 
    init(id: String?,
         owner: String?,
         secret: String?,
         server: String?,
         farm: Int?,
         title: String?,
         ispublic: Bool?,
         isfriend: Bool?,
         isfamily: Bool?)
    {
        self.id         = id  ?? ""
        self.owner      = owner ?? ""
        self.secret     = secret ?? ""
        self.farm       = farm ?? 0
        self.title      = title ?? ""
        self.server     = server ?? ""
        self.ispublic   = ispublic ?? false
        self.isfriend   = isfriend ?? false
        self.isfamily   = isfamily ?? false 
    }
}
