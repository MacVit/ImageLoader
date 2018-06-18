//
//  NetworkService.swift
//  ImageLoader
//
//  Created by Vitaliy Maksymlyuk on 6/17/18.
//  Copyright © 2018 Vitaliy Maksymlyuk. All rights reserved.
//

import UIKit

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    
    let urlPath: String = ""
    
    func imageRequest(_ completionHandler: @escaping (URL) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.downloadImageDataTask(completionHandler)?.resume()
        }
    }
    
    func downloadImageDataTask(_ completionHandler: (URL) -> Void) -> URLSessionDataTask? {
        if let url = URL(string: urlPath) {
            return URLSession.shared.dataTask(with: url, completionHandler: { (data, responce, error) in
                if let data = data, let downloadedImage = UIImage(data: data), error == nil { return }
                
                
            })
        }
        
        return nil
    }
    
    func downloadImage(from url: URL) {
        
        let sesion = URLSession.shared
        
        let task = sesion.dataTask(with: url) { (data, responce, error) in
            
            
        }
        
        task.resume()
        
    }
}
