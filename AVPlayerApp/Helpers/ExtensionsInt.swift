//
//  ExtensionsInt.swift
//  AVPlayerApp
//
//  Created by Max Ward on 29/07/2023.
//

import Foundation

extension Int {
    mutating func increase() {
        self += 1
    }
    
    mutating func decrease() {
        self -= 1
    }
}


extension Bool {
    mutating func playing() {
        self = true
    }
    
    mutating func paused() {
        self = false
    }
}
