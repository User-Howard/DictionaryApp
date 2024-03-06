//
//  Item.swift
//  Dictionary
//
//  Created by Howard Wu on 2024/3/6.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
