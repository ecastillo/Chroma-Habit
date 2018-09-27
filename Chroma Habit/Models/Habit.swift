//
//  Habit.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    @objc dynamic var order = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
