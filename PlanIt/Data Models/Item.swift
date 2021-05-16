//
//  Task.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-16.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var task: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
