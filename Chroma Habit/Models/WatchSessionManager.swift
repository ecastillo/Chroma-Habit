//
//  WatchSessionManager.swift
//  Chroma Habit
//
//  Created by Eric Castillo on 10/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["test"] as! Bool == true {
            let hmm = DBManager.shared.getHabits()
            
            var watchHabits = [WatchHabit]()
            for habit in hmm {
                let watchHabit = WatchHabit()
                watchHabit.habitId = habit.id
                watchHabit.habitName = habit.name
                watchHabit.habitColor = habit.color
                if let _ = DBManager.shared.getRecord(for: habit, on: Date()) {
                    watchHabit.done = true
                }
                watchHabits.append(watchHabit)
            }
            
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(watchHabits) else {
                fatalError("oh no!")
            }
            
            replyHandler(["response": data])
            //sendDataToWatch()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("recieved data from watch")
        
        let jsonDecoder = JSONDecoder()
        guard let watchHabit = try? jsonDecoder.decode(WatchHabit.self, from: messageData) else {
            fatalError("Couldn't decode data from watch")
        }
        print("habit received from watch to phone: \(watchHabit.habitName!), with done: \(watchHabit.done)")
        DispatchQueue.main.async {
            if let habit = DBManager.shared.getHabit(withId: watchHabit.habitId!) {
                if watchHabit.done {
                    DBManager.shared.createRecord(habit: habit, date: Date())
                } else {
                    DBManager.shared.deleteRecord(for: habit, on: Date())
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: recordModifiedOnWatchNotificationID), object: self)
            }
        }
    }
    
    func sendDataToWatch() {
        let hmm = DBManager.shared.getHabits()
        
        var watchHabits = [WatchHabit]()
        for habit in hmm {
            let watchHabit = WatchHabit()
            watchHabit.habitId = habit.id
            watchHabit.habitName = habit.name
            watchHabit.habitColor = habit.color
            if let _ = DBManager.shared.getRecord(for: habit, on: Date()) {
                watchHabit.done = true
            }
            watchHabits.append(watchHabit)
        }
        
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(watchHabits) else {
            fatalError("oh no!")
        }
        session?.sendMessageData(data, replyHandler: nil, errorHandler: nil)
    }
}
