//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Eric Castillo on 9/29/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    let initialConnectionSuccessful = false
    @IBOutlet weak var errorLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceDate!
    @IBOutlet weak var habitsTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: habitDataReceivedFromPhoneNotificationID), object: nil)
        
        dateLabel.setHidden(true)
        habitsTable.setHidden(true)
    }
    
    @objc func refresh() {
        //errorLabel.setText("connected!")
        errorLabel.setHidden(true)
        dateLabel.setHidden(false)
        habitsTable.setHidden(false)
        
        habitsTable.setNumberOfRows(watchHabits.count, withRowType: "HabitRow")
        for (i, watchHabit) in watchHabits.enumerated() {
            if let row = habitsTable.rowController(at: i) as? HabitRowController {
                row.name.setText(watchHabit.habitName)
                row.separator.setColor(UIColor(hexString: (watchHabit.habitColor)!))
                if watchHabit.done {
                    row.group.setBackgroundColor(UIColor(hexString: (watchHabit.habitColor)!))
                } else {
                    row.group.setBackgroundColor(UIColor(hexString: "1A1A1A"))
                }
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
//        if !PhoneSessionManager.shared.session!.isReachable {
//            errorLabel.setText("no connection")
//        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print("row selected")
        watchHabits![rowIndex].done = !watchHabits![rowIndex].done
        let watchHabit = watchHabits![rowIndex]
        
        let row = habitsTable.rowController(at: rowIndex) as! HabitRowController
        if watchHabit.done {
            row.group.setBackgroundColor(UIColor(hexString: watchHabit.habitColor!))
        } else {
            row.group.setBackgroundColor(UIColor(hexString: "1A1A1A"))
        }
        
        PhoneSessionManager.shared.sendDataToPhone(data: watchHabit)
    }

}
