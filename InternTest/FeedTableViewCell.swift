//
//  FeedTableViewCell.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/27/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit

class FeedTableViewCell: UITableViewCell {
    
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    var object: User? {
        didSet {
            
            activityIndicator.startAnimating()
            object?.imageView?.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "image") {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.stopAnimating()
            
        }
    }
    deinit {
        object?.imageView?.removeObserver(self, forKeyPath: "image")
    }
}
