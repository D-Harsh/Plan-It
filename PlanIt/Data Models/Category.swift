//
//  Category.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-16.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
