//
//  Item.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-15.
//

import Foundation


class Item: Codable {
    var task: String = ""
    var isDone = false
    
    init(task: String) {
        self.task = task
    }
    
    init() {
        
    }
}
