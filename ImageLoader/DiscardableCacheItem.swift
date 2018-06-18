//
//  DiscardableCacheItem.swift
//  ImageLoader
//
//  Created by Vitaliy Maksymlyuk on 6/18/18.
//  Copyright © 2018 Vitaliy Maksymlyuk. All rights reserved.
//

import Foundation

class DiscardableCacheItem: NSObject, NSDiscardableContent {
    
    private(set) public var data: NSData?
    var accessCount: UInt = 0
    
    public init(data aData: NSData) {
        data = aData
    }
    
    public func beginContentAccess() -> Bool {
        if data == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            data = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return data == nil
    }
    
}
