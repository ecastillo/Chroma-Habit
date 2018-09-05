//
//  List.swift
//  HabitApp
//
//  Created by Eric Castillo on 9/3/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import RealmSwift

class HabitList: Object {
    @objc dynamic var id = UUID().uuidString
    let habits = List<Habit>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
