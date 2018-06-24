//
//  Utility.swift 
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//
import UIKit

class Utility: NSObject {
    /// parse the json
   ///
   /// - Parameter dict: dictonary JSON
   /// - Returns: array of Photo
   static func parseJSON(dict: Dictionary<String, Any>?)-> [Photo] {
    guard let jsonDict   = dict  else{return [] }
    guard let jDict   = jsonDict["photos"] as? Dictionary<String, Any? >  else{return [] }
    guard let pArr = jDict["photo"] as? Array<Any?> else {return  [] }
        var photos = [Photo]()
        
        for (_,element) in pArr.enumerated(){
            if  let photo = element as? Dictionary< String, Any>{
                let id  = photo["id"] ?? ""
                let owner = photo["owner"] ?? ""
                let secret = photo["secret"] ?? ""
                let server = photo["server"] ?? ""
                let farm = photo["farm"] ?? 0
                let title = photo["title"] ?? ""
                let ispublic = photo["ispublic"] ?? false
                let isfriend = photo["isfriend"] ?? false
                let isfamily = photo["isfamily"] ?? false
                let pic = Photo(id: id as? String,
                                owner: owner as? String,
                                secret: secret as? String,
                                server: server as? String,
                                farm: farm as? Int ,
                                title: title as? String,
                                ispublic: ispublic as? Bool ,
                                isfriend: isfriend as? Bool ,
                                isfamily: isfamily as? Bool )
                photos.append(pic)
            }
        }
        return photos
    }
    
    class func showAlertMessageVC(_ viewC: UIViewController,_ message: String, withTitle title: String, onClick completion: @escaping () -> Void) {
        let alert = UIAlertController(title: " \(title)", message: message, preferredStyle: .alert)
        //Add Buttons
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //Handle button action here
            completion()
        })
        alert.addAction(okButton)
        viewC.present(alert, animated: true, completion: nil )
        
    }
    
    class func showAlertMessage(_ message: String, withTitle title: String, onClick completion: @escaping () -> Void) {
        let alert = UIAlertController(title: " \(title)", message: message, preferredStyle: .alert)
        //Add Buttons
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //Handle button action here
            completion()
        })
        alert.addAction(okButton)
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - IMAGE file storage and retrieval 
    class func storeFile(_ fileID: String, _ imageData: Data )->Bool{
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileID)
            try imageData.write(to: fileURL)
            return true
        } catch {
            print(error)
        }
        return false
        
    }
    
    class func getImageFile(_ fileID: String)->UIImage?{
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileID)
            let filePath = fileURL.path 
            if fileManager.fileExists(atPath: filePath) {
                let dataFile =  try Data(contentsOf: fileURL, options: .alwaysMapped)
                    if let image = UIImage(data: dataFile){
                        return image
                    }
                }
            } catch {
                print(error)
                return nil
            }
        return nil
    }
    

}
