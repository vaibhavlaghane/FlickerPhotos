//
//  NetworkManager.swift
 
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//


import UIKit

struct Constants {
    struct APIDetails { 
        static let APIScheme    = "https"
        static let APIHost      = "api.flickr.com"
        static let APIPath      = "/services/rest/"
        static let method       = "method=flickr.photos.search"
        static let APIKey       = "api_key=3e7cc266ae2b0e0d78e279ce8e361736"
        static let formatjson   = "format=json"
        static let nojsoncallback   = "nojsoncallback=1"
        static let safeSearch   = "safe_search=1"
        static let text         = "text="
        static let page = "page="
        static let perPage = "page_page="
    }
}

class DataDownloader: NSObject {

    /// function call to get JSON data
    /// completion block handles the received JSON
    /// - Returns: none
    internal func getJSONData( pageNumber: Int, pageSize: Int , searchText: String  , completion: @escaping (Dictionary<String, Any >? ) -> Void , failure: @escaping (URLResponse? , Error? ) -> Void  )->Void   {
        var pageNumStr = String( pageNumber)
        var pageSizeStr = String(pageSize)
        if   pageNumber < 1  {
            pageNumStr = "1"
        }
        if (pageSize > 30 || pageSize < 1){
            pageSizeStr = "30"
        }
        let urlUsr = createURLFromParameters(  pageSizeStr,  pageNumStr, searchText ) ;
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: urlUsr  )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: request as URLRequest){(data: Data?,response: URLResponse?, error: Error?) -> Void in
            if let responseData = data
            {
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    //print(json)
                    completion(json as? Dictionary<String, Any >)
                }catch{
                    print("Could not serialize")
                    completion(nil)
                }
            }
            }.resume()
    }

    ///  function to create URL using the paramenters
    /// - Parameters:
    ///   - pageSize: page size
    ///   - pageNumber: page number 
    /// - Returns: url
    internal func createURLFromParameters(_ pageSize:  String, _ pageNumber: String, _ searchText: String ) -> URL {
        var components      = URLComponents()
        components.scheme   = Constants.APIDetails.APIScheme
        components.host     = Constants.APIDetails.APIHost
        components.path     = Constants.APIDetails.APIPath 
        components.query = Constants.APIDetails.method
            + "&" + Constants.APIDetails.APIKey
            + "&" + Constants.APIDetails.formatjson
            + "&" + Constants.APIDetails.nojsoncallback
            + "&" + Constants.APIDetails.safeSearch
            + "&" + Constants.APIDetails.text + searchText
            + "&" + Constants.APIDetails.page + pageNumber
            + "&" + Constants.APIDetails.perPage + pageSize
        return components.url!
    }
}
