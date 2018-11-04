//
//  PhoneSessionManager.swift
//  Chroma Habit
//
//  Created by Eric Castillo on 10/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import WatchConnectivity

let habitDataReceivedFromPhoneNotificationID = "com.chromahabit.watchkitapp.watchkitextension.habitDataReceivedFromPhoneNotificationID"
let recordDataReceivedFromPhoneNotificationID = "com.chromahabit.watchkitapp.watchkitextension.recordDataReceivedFromPhoneNotificationID"

class PhoneSessionManager: NSObject, WCSessionDelegate {
    static let shared = PhoneSessionManager()
    var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete on watch")
        requestDataFromPhone(completion: nil)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        let jsonDecoder = JSONDecoder()
        let data = try! jsonDecoder.decode([WatchHabit].self, from: messageData)
        watchHabits = data
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: habitDataReceivedFromPhoneNotificationID), object: self)
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
    
    func requestDataFromPhone(completion: (() -> ())?) {
        session?.sendMessage(["test": true], replyHandler: { messageDict in
            print("i think we got a reply from phone?")
            let jsonDecoder = JSONDecoder()
            let data = try! jsonDecoder.decode([WatchHabit].self, from: messageDict["response"] as! Data)
            watchHabits = data
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: habitDataReceivedFromPhoneNotificationID), object: self)
            completion?()
            return
        }, errorHandler: { error in
            print("couldn't send message to phone")
            return
        })
    }
}
