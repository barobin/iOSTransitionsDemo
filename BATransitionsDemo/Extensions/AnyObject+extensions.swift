//
//  AnyObject+extensions.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import Foundation

extension NSObject {
    
    public class var className: String {
        guard let normalClassName = String(describing: self).components(separatedBy: ".").last else {
            return NSStringFromClass(self)
        }
        
        return normalClassName
    }
    
    public var className: String {
        return type(of: self).className
    }
    
}
