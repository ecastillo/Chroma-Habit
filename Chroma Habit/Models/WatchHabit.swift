//
//  WatchHabit.swift
//  Watch Extension
//
//  Created by Eric Castillo on 9/30/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

class WatchHabit: Codable {
    var habitId: String?
    var habitName: String?
    var habitColor: String?
    var done: Bool = false
}
