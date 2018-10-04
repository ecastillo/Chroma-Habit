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
    @objc public dynamic var id = UUID().uuidString
    @objc public dynamic var name = ""
    @objc public dynamic var color = ""
    @objc public dynamic var order = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
