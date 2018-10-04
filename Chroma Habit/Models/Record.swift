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
    @objc public dynamic var date = ""
    @objc public dynamic var habit: Habit?
}
