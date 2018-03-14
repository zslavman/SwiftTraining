//
//  Loader.swift
//  04_Eateries
//
//  Created by Admin on 13.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ImageLoader:UIImageView {

    
    static var globalCache = NSCache<NSString, AnyObject>()
    var activeLink:String = ""
    

    
    
    public func loadImageWithUrl(_ url: URL) {
        
        image = nil
        
        // retrieves image if already available in cache
        if let imageFromCache = ImageLoader.globalCache.object(forKey: (url as AnyObject) as! NSString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        // image does not available in cache.. so retrieving it from url...
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
//                    if self.imageURL == url {
//                        self.image = imageToCache
//                    }
                    ImageLoader.globalCache.setObject(imageToCache, forKey: (url as AnyObject) as! NSString)
                }
            })
        })
        task.resume()
    }

}
