//
//  Extensions.swift
//  InternTest
//
//  Created by Rahul Sheth on 5/20/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import UIKit


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadIntoCache(urlString: String) {
        //load image into cache
        if (imageCache.object(forKey: urlString as AnyObject) as? UIImage) != nil {
            return
        }

            let url = NSURL(string: urlString)
            let request = URLRequest(url: url as! URL)
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
               

                if (error != nil) {
                    print("Here is your error", error)
                    return
                }
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        if let cachedImage = UIImage(data: data!) {
                            imageCache.setObject(cachedImage, forKey: urlString as AnyObject)
                        }
                    }
                }
        }).resume()
    }
    
    func loadImageUsingCacheWithURLString(urlString: String) -> Bool {
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
         
            self.image = imageFromCache
            return true
        }
        let url = NSURL(string: urlString)
        let request = URLRequest(url: url as! URL)
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if (error != nil) {
                print("Here is your error", error)
                self.image = UIImage(named: "VideoUnavailable")
                DispatchQueue.main.async {
                    self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2).isActive = true

                }               
                return
            }
            
            
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        if let cachedImage = UIImage(data: data!) {
                            
                            imageCache.setObject(cachedImage, forKey: urlString as AnyObject)
                            
                            self.image = UIImage(data: data!)
                        }
                        

                    }
                    
            }
        }).resume()
        return true
    }
    
}
