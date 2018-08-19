//
//  Database.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/16/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    static let shared = Database()
    
    let realm = try! Realm()
    func getHabits() -> Results<Habit> {
        return realm.objects(Habit.self)
    }
}
