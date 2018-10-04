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


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession?
    var watchHabits: [WatchHabit]!
    //let realm = try! Realm()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete on watch")
        
        session.sendMessage(["test": true], replyHandler: { ([String : Any]) in
            print("i think we got a reply from phone?")
            return
        }, errorHandler: nil)
    }
    
//    func session(_ session: WCSession, didReceive file: WCSessionFile) {
//        print("recieved a file!")
//        var config = Realm.Configuration()
//        config.fileURL = file.fileURL
//        Realm.Configuration.defaultConfiguration = config
//
//        habits = DBManager.shared.getHabits()
//        habitsTable.setNumberOfRows(habits.count, withRowType: "HabitRow")
//        for (i, habit) in habits.enumerated() {
//            if let row = habitsTable.rowController(at: i) as? HabitRowController {
//                row.name.setText(habit.name)
//                row.separator.setColor(UIColor(hexString: habit.color))
//                if let _ = DBManager.shared.getRecord(for: habit, on: Date()) {
//                    row.group.setBackgroundColor(UIColor(hexString: habit.color))
//                }
//            }
//        }
//    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        let jsonDecoder = JSONDecoder()
        let data = try! jsonDecoder.decode([WatchHabit].self, from: messageData)
        watchHabits = data
        
        habitsTable.setNumberOfRows(data.count, withRowType: "HabitRow")
        for (i, watchHabit) in data.enumerated() {
            if let row = habitsTable.rowController(at: i) as? HabitRowController {
                row.name.setText(watchHabit.habitName)
                row.separator.setColor(UIColor(hexString: (watchHabit.habitColor)!))
                if watchHabit.done {
                    row.group.setBackgroundColor(UIColor(hexString: (watchHabit.habitColor)!))
                }
            }
        }
    }
    
    func sendDataToPhone(data: WatchHabit) {
        print("sending data to phone")
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(data) else {
            fatalError("Couldn't encode data from watch")
        }
        print("habit to send from watch to phone: \(data.habitName!), with done: \(data.done)")
        session!.sendMessageData(jsonData, replyHandler: nil, errorHandler: nil)
    }

    @IBOutlet weak var habitsTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            session = WCSession.default
            session!.delegate = self
            session!.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
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
            row.group.setBackgroundColor(UIColor.Theme.clear)
        }
        
        sendDataToPhone(data: watchHabit)
    }

}
