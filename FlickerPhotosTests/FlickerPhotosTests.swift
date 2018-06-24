//
//  FlickerPhotosTests.swift
//  FlickerPhotosTests
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import XCTest
@testable import FlickerPhotos

class FlickerPhotosTests: XCTestCase {
    private var dataCall:DataDownloader? = nil
    private var netOps: NetworkOperationManager? = nil
    private var photos: [Photo]? = nil
    private var photo: Photo? = nil
    private var imageLink: String =  "http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataCall = DataDownloader()
        netOps = NetworkOperationManager()
        photo = Photo(id: "23451156376", owner: "28017113@N08", secret: "8983a8ebc7", server: "578", farm: 1, title: "Merry Christmas!", ispublic: true, isfriend: false, isfamily: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNetworkOperation(){
        XCTAssertNotNil(netOps)
        XCTAssertNotNil(dataCall)
    }
    
    func testURLCreation(){
        let url = dataCall?.createURLFromParameters("30", "1", "kittens")
        XCTAssertNotNil(url)
        print(url ?? " ");
    }
    
    func testNetworkCall(){
        let expectation = self.expectation(description: "fetch photo")
        dataCall?.getJSONData( pageNumber: 1, pageSize: 2, searchText: "dogs", completion: { (dict ) in
            XCTAssertNotNil(dict)
            print(dict ?? "")
            expectation.fulfill()
        },failure: {( response, error) in
            //
        })
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testgetPhoto(){
        let expectation = self.expectation(description: "fetch photo")
        dataCall?.getJSONData( pageNumber: 1, pageSize: 20, searchText: "dogs", completion: { (dict ) in
            XCTAssertNotNil(dict)
            print(dict ?? "")
            let pList = Utility.parseJSON(dict: dict)
            XCTAssertNotNil(pList)
            let photo = pList[0]
            XCTAssertNotNil(photo)
            expectation.fulfill()
        },failure: {( response, error) in})
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testgetPhotoNetOpsAndImageDownload(){
        let expectation = self.expectation(description: "fetch photo")
        netOps?.downloadData(pageNumber: 1, pageSize: 100, searchText: "kittens",   completion: { (photos ) in
            XCTAssertNotNil(photos)
            self.photos = photos
            if let pList = photos {
            XCTAssertNotNil(pList)
            XCTAssertEqual(pList.count, 100)
            let photo = pList[0]
            XCTAssertNotNil(photo)
            }
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        if let pic: Photo  = photos?[0]{
            XCTAssertNotNil(pic.imageData)
        }else{
            XCTFail("testgetPhotoNetOps - photo not available ")
        }
    }
    
    func testGetImage(){
//        if let pic = photo{
//        netOps?.startDownloadPhotoImage(photo: pic, index: 1)
//        }
    }
    
    func testimageDownloader(){
        var imageData: Data? = nil
        if let imgURL =   URL.init(string: imageLink) {
            imageData =   try? Data(contentsOf: imgURL)
        }
        XCTAssertNotNil(imageData)
    }
    
    func testFileStore(){
        var imageData: Data? = nil
        if let imgURL =   URL.init(string: imageLink) {
            imageData =   try? Data(contentsOf: imgURL)
        }
        let id  = "1234lkjhgfetrwe"
        if let img   =  imageData{
            XCTAssertTrue (  Utility.storeFile(id , img) ) 
            let imgStored = Utility.getImageFile(id )
            XCTAssertNotNil(imgStored)
        }
    }
}
