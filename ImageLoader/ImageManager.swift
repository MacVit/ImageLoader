//
//  ImageManager.swift
//  ImageLoader
//
//  Created by Vitaliy Maksymlyuk on 6/18/18.
//  Copyright © 2018 Vitaliy Maksymlyuk. All rights reserved.
//

import UIKit

class ImageManager: NSObject {
    
    static let shared = ImageManager()
    
    private var items = [String: DispatchWorkItem]()
    
    func cancel(forURL URL: URL) {
        let item = items[URL.absoluteString]
        
        if let isCancelled = item?.isCancelled, isCancelled == false {
            item?.cancel()
        }
        
        items[URL.absoluteString] = nil
    }
    
    func requestImage(URL: URL, completionHandler: @escaping (Data, URL) -> Void) {
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let weakSelf = self else { return }
            
            if let cached = weakSelf.cached(forURL: URL) {
                completionHandler(cached, URL)
            } else if let data = try? Data(contentsOf: URL) {
                Cache.shared.setData(data, forKey: URL.absoluteString)
                weakSelf.items[URL.absoluteString] = nil
                completionHandler(data, URL)
            }
        }
        
        execute(dispatchWorkItem, URL: URL)
    }
    
    // MARK: Private methods
    
    private func cached(forURL URL: URL) -> Data? {
        if let cachedData = Cache.shared.dataForKey(URL.absoluteString) {
            return cachedData
        }
        
        return nil
    }
    
    private func execute(_ item: DispatchWorkItem, URL: URL) {
        items[URL.absoluteString] = item
        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }
}
