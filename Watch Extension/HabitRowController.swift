//
//  HabitRowController.swift
//  Watch Extension
//
//  Created by Eric Castillo on 9/29/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import WatchKit

class HabitRowController: NSObject {

    @IBOutlet weak var name: WKInterfaceLabel!
    @IBOutlet weak var separator: WKInterfaceSeparator!
    @IBOutlet weak var group: WKInterfaceGroup!
    var done: Bool?
}
