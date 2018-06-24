//
//  InfiniteScrollControllerTableViewController.swift
//  FlickerPhotos
//
//  Created by vlaghane on 6/24/18.
//  Copyright © 2018 TestUber. All rights reserved.
//

import UIKit

extension PhotoScrollViewController{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollReachedBottom = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(self.scrollReachedBottom){
            if(self.currSearch == .none){
                self.addLoadingIndicator()
            }
        }
        print("scrollViewDidEndDecelerating")
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            self.scrollReachedBottom = true
            print("Reached Bottom ")
        }
        if (scrollView.contentOffset.y <= 0){
        }
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
        }
    }
    
     func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print("scrollViewDidChangeAdjustedContentInset")
    }
    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
          print("scrollViewDidEndDragging")
    }
    
     func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
          print("scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    }
    
    //MARK - activity indicator for infinite search
    internal func addLoadingIndicator(){
        if(self.currSearch == .none ){
            let bottomX = self.view.bounds.size.width
            let bottomY = self.view.bounds.size.height
            self.activtyInd = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.activtyInd.frame = CGRect(x: bottomX/2 , y: bottomY - 50, width: 50, height: 50)
            self.activtyInd.backgroundColor = UIColor.white
            DispatchQueue.main.async {
                self.activtyInd.startAnimating()
            }
            self.view.addSubview(self.activtyInd)
            self.view.bringSubview(toFront: self.activtyInd)
            self.searchPhoto()
            self.currSearch = .infiniteSearch
        }
    }
    

    
}


