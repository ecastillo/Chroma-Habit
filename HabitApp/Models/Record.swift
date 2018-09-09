//
//  Record.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var date = ""
    @objc dynamic var habit: Habit?
}
