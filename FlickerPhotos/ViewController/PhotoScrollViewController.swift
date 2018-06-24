//
//  PhotoScrollViewController.swift
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import UIKit

protocol PhotoSearchDelegate {
    func searchPhoto(text: String )
}

enum SearchProgress{
    case infiniteSearch
    case searchBarSearch
    case none
}

let cellIdentifier = "kphotoCell"
let photoCellXib = "PhotoTableViewCell"
let cellHeight: CGFloat = 100

class PhotoScrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    @IBOutlet weak var table1: UITableView!
    @IBOutlet weak var table2: UITableView!
    @IBOutlet weak var table3: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    internal var table1photos = [Photo]()
    internal var table2photos = [Photo]()
    internal var table3photos = [Photo]()
    internal var table1photosNoImages = [Photo]()
    internal var table2photosNoImages = [Photo]()
    internal var table3photosNoImages = [Photo]()
    internal weak var delegate: PhotosViewModel? = nil
    internal var activtyInd = UIActivityIndicatorView()
    internal var currSearch = SearchProgress.none
    internal var scrollReachedBottom = false
    
    private var strongDelegate: PhotosViewModel? = nil
    private var searchText = ""
    ///Cell IMAGE height width
    private var rowHeightsT1:[Int:CGFloat] = [:]
    private var rowHeightsT2:[Int:CGFloat] = [:]
    private var rowHeightsT3:[Int:CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: photoCellXib, bundle: nil )
        self.table1.register(nibCell, forCellReuseIdentifier: cellIdentifier)
        self.table2.register(nibCell, forCellReuseIdentifier: cellIdentifier)
        self.table3.register(nibCell, forCellReuseIdentifier: cellIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedImage(notification:)), name: NSNotification.Name(rawValue:receivedImageNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedImage(notification:)), name: NSNotification.Name(rawValue:failedImageNotification) , object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Update the delegate
    func setDelegate( _ delegate: PhotosViewModel){
        self.delegate = delegate
        self.strongDelegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == table1){
            return table1photos.count
        }
        if(tableView == table2){
            return table2photos.count
        }
        if(tableView == table3){
            return table3photos.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PhotoTableViewCell{
            if(tableView == table1){
                self.cellImageContents(indexPath, cell , tableView, table1photos)
            }
            if(tableView == table2){
               self.cellImageContents(indexPath, cell , tableView, table2photos)
            }
            if(tableView == table3){
               self.cellImageContents(indexPath, cell , tableView, table3photos)
            }
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var currRW = [Int:CGFloat] ()
        if( tableView == self.table1 ){
            currRW = self.rowHeightsT1
        }else if( tableView == self.table2){
            currRW =  self.rowHeightsT2
        }else if( tableView == self.table3){
            currRW = self.rowHeightsT3
        }
        if let height = currRW[indexPath.row] {
            return height
        }
        return cellHeight
    }
    
    internal func updateImage( _ id: String , _ downloadFailed: Bool  ){
        if (self.table1photos.count != 0 ){
            for (i, element ) in self.table1photos.enumerated(){
                if( element.id == id ){
                    DispatchQueue.main.async {
                        if (self.table1 != nil){
                            let indexPath =  IndexPath(row: i, section: 0)
                            if(downloadFailed){
                                self.table1photos.remove(at: i )
                                self.table1.reloadData()
                            }else{
                            self.table1.reloadRows(at: [indexPath], with: .top)
                            }
                        }
                    }
                return
                }
            }
        }
        if(self.table2photos.count  != 0){
            for (i, element ) in self.table2photos.enumerated(){
                if( element.id == id ){
                    DispatchQueue.main.async {
                        if (self.table2 != nil){
                            let indexPath =  IndexPath(row: i, section: 0)
                            self.table2.reloadRows(at: [indexPath], with: .top)
                        }
                    }
                return
                }
            }
        }
        if(self.table3photos.count  != 0 ){
            for (i, element ) in self.table3photos.enumerated(){
                if( element.id == id ){
                    DispatchQueue.main.async {
                        if (self.table3 != nil){
                            let indexPath =  IndexPath(row: i, section: 0)
                            self.table3.reloadRows(at: [indexPath], with: .top)
                        }
                    }
                return 
                }
            }
        }
     }
    
    internal func appendData(_ d1: [Photo], _ d2: [Photo], _ d3: [Photo], _ isNewText: Bool ){
        self.currSearch = .none
        removeLoadingIndicator()
        if (d1.count == 0 && d2.count == 0 && d3.count == 0){return}
        if(isNewText){
            DispatchQueue.main.sync  {
                if (self.table1 != nil){
                    self.table1photos.removeAll()
                    self.table1.reloadData()
                }
                if(self.table2 != nil ){
                    self.table2photos.removeAll()
                    self.table2.reloadData()
                }
                if(self.table3 != nil ){
                    self.table3photos.removeAll()
                    self.table3.reloadData()
                }
            }
        }
        if(d1.count != 0){
            self.table1photos.append(contentsOf: d1 )
            DispatchQueue.main.async {
                if (self.table1 != nil){
                self.table1.reloadData()
                }
            }
        }
        if(d2.count != 0){
            self.table2photos.append(contentsOf: d2 )
            DispatchQueue.main.async {
                if(self.table2 != nil ){
                self.table2.reloadData()
                }
            }
        }
        if(d3.count != 0){
            self.table3photos.append(contentsOf: d3 )
            DispatchQueue.main.async {
                if(self.table3 != nil ){
                self.table3.reloadData()
                }
            }
        }
    }
    //MARK - search Bar delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if(self.delegate == nil){
            self.delegate = self.strongDelegate
        }
        self.delegate?.searchPhoto(text: self.searchText)
        print("Did end editing ")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    internal func searchPhoto()
    {
        delegate?.searchPhoto(text: searchText)
    }
    
    //MARK - notfication received for image download
    @objc func receivedImage( notification: Notification){
        if let id = notification.userInfo?["id"] as? String{
            self.updateImage(  id , false )
        }
    }
    @objc func failedImage( notification: Notification){
        if let id = notification.userInfo?["id"] as? String{
            self.updateImage(  id , true  )
        }
    }
    
    //Loading indicator management
    func removeLoadingIndicator(){
        DispatchQueue.main.async {
            self.activtyInd.stopAnimating()
            for (_ , vW) in self.view.subviews.enumerated(){
                if(vW == self.activtyInd){
                    self.view.willRemoveSubview(vW )
                }
            }
        }
        self.currSearch = .none
    }
    
    private func cellImageContents(_ indexP: IndexPath, _ cell: PhotoTableViewCell, _ table: UITableView, _ tablePhotos: [Photo]) {
        let photo = tablePhotos[indexP.row]
        cell.textLabel?.text = nil
        cell.imageV?.image = photo.imageData
        if let image = photo.imageData{
            print(indexP.row ," image is present ")
            cell.imageV?.image = image
            cell.textLabel?.text = nil
        }else{
            cell.textLabel?.text = photo.title
            print(indexP.row ,   "  image is  NOT present ")
            //cell.imageV?.image = nil
        }
        
                if let image = photo.imageData{
                    DispatchQueue.main.async {
                        cell.imageV.image = image
                        let aspectRatio = (image as UIImage).size.height/(image as UIImage).size.width
                        let imageHeight = cell.frame.width*aspectRatio
                        if( table == self.table1 ){
                        self.rowHeightsT1[indexP.row] = imageHeight
                        }else if( table == self.table2){
                            self.rowHeightsT2[indexP.row] = imageHeight
                        }else {
                            self.rowHeightsT3[indexP.row] = imageHeight
                        }
                    }
                }
    }
          
}
