//
//  DBManager.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/16/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class DBManager {
    
    static let shared = DBManager()
    //let realm = try! Realm()
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getHabit(withId id: String) -> Habit? {
        let realm = try! Realm()
        return realm.object(ofType: Habit.self, forPrimaryKey: id)
    }
    
    func getHabits() -> Results<Habit> {
        let realm = try! Realm()
        return realm.objects(Habit.self).sorted(byKeyPath: "order")
        //return realm.objects(HabitList.self).first?.habits
    }
    
    func createHabit(name: String, color: UIColor) {
        let realm = try! Realm()
        
        let newHabit = Habit()
        newHabit.name = name
        newHabit.color = color.hexString
        
        try! realm.write {
            let habits = getHabits()
            //if let habits = allHabits {
            if habits.count > 0 {
                let maxOrder = habits.max(by: { $0.order < $1.order })?.order
                newHabit.order = maxOrder! + 1
            } else {
                newHabit.order = 0
            }
            
            //let habitList = realm.objects(HabitList.self).first
        
            realm.add(newHabit)
            //habitList?.habits.append(newHabit)
            //realm.add(habitList!, update: true)
        }
        //}
    }
    
    func deleteHabit(habit: Habit) {
        let realm = try! Realm()
        
        try! realm.write {
            let records = getRecords(for: habit)
            realm.delete(records)
            realm.delete(habit)
        }
    }
    
    func updateHabit(_ habit: Habit, name: String?, color: UIColor?) {
        let realm = try! Realm()
        
        try! realm.write {
            habit.name = name ?? habit.name
            habit.color = color?.hexString ?? habit.color
        }
    }
    
    func updateHabitOrder(from: Int, to: Int) {
        let realm = try! Realm()
        
        try! realm.write {
            let habits = getHabits()
            for habit in habits {
                if from < to {
                    if habit.order == from {
                        habit.order = to
                    } else if habit.order > from && habit.order <= to {
                        habit.order = habit.order - 1
                    }
                } else {
                    if habit.order == from {
                        habit.order = to
                    } else if habit.order >= to && habit.order < from {
                        habit.order = habit.order + 1
                    }
                }
            }
        
            //habitList?.habits.move(from: from, to: to)
            //realm.add(habits, update: true)
        }
    }
    
    func getRecords(on date: Date) -> Results<Record> {
        let realm = try! Realm()
        
        let dateString = dateFormatter.string(from: date)
        let predicate = NSPredicate(format: "date = %@", dateString)
        return realm.objects(Record.self).filter(predicate)
    }
    
    func getRecords(for habit: Habit) -> Results<Record> {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "habit.id = %@", habit.id)
        return realm.objects(Record.self).filter(predicate)
    }
    
    func getRecord(for habit: Habit, on date: Date) -> Record? {
        let realm = try! Realm()
        
        let dateString = dateFormatter.string(from: date)
        let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", habit.id, dateString)
        return realm.objects(Record.self).filter(predicate).first
    }
    
    func createRecord(habit: Habit, date: Date) {
        let realm = try! Realm()
        
        let newRecord = Record()
        newRecord.habit = habit
        newRecord.date = dateFormatter.string(from: date)
        
        try! realm.write {
            realm.add(newRecord)
        }
    }
    
    func deleteRecord(for habit: Habit, on date: Date) {
        let realm = try! Realm()
        
        try! realm.write {
            if let record = getRecord(for: habit, on: date) {
                realm.delete(record)
            }
        }
    }
}


//
//class DBManager2 {
//
//    //static let shared = DBManager()
//    //let realm = try! Realm()
//    let dateFormatter = DateFormatter()
//
//    init() {
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//    }
//
//    func getHabits() -> Results<Habit> {
//        let realm = try! Realm()
//        return realm.objects(Habit.self).sorted(byKeyPath: "order")
//        //return realm.objects(HabitList.self).first?.habits
//    }
//
//    func createHabit(name: String, color: UIColor) {
//        let realm = try! Realm()
//
//        let newHabit = Habit()
//        newHabit.name = name
//        newHabit.color = color.hexString
//
//        let habits = getHabits()
//        //if let habits = allHabits {
//        if habits.count > 0 {
//            let maxOrder = habits.max(by: { $0.order < $1.order })?.order
//            newHabit.order = maxOrder! + 1
//        } else {
//            newHabit.order = 0
//        }
//
//        //let habitList = realm.objects(HabitList.self).first
//
//        try! realm.write {
//            realm.add(newHabit)
//            //habitList?.habits.append(newHabit)
//            //realm.add(habitList!, update: true)
//        }
//        //}
//    }
//
//    func deleteHabit(habit: Habit) {
//        let realm = try! Realm()
//
//        try! realm.write {
//            let records = getRecords(for: habit)
//            realm.delete(records)
//            realm.delete(habit)
//        }
//    }
//
//    func updateHabit(_ habit: Habit, name: String?, color: UIColor?) {
//        let realm = try! Realm()
//
//        try! realm.write {
//            habit.name = name ?? habit.name
//            habit.color = color?.hexString ?? habit.color
//        }
//    }
//
//    func updateHabitOrder(from: Int, to: Int) {
//        let realm = try! Realm()
//
//        let habits = getHabits()
//
//        try! realm.write {
//            for habit in habits {
//                if from < to {
//                    if habit.order == from {
//                        habit.order = to
//                    } else if habit.order > from && habit.order <= to {
//                        habit.order = habit.order - 1
//                    }
//                } else {
//                    if habit.order == from {
//                        habit.order = to
//                    } else if habit.order >= to && habit.order < from {
//                        habit.order = habit.order + 1
//                    }
//                }
//            }
//
//
//            //habitList?.habits.move(from: from, to: to)
//            //realm.add(habits, update: true)
//        }
//    }
//
//    func getRecords(on date: Date) -> Results<Record> {
//        let realm = try! Realm()
//
//        let dateString = dateFormatter.string(from: date)
//        let predicate = NSPredicate(format: "date = %@", dateString)
//        return realm.objects(Record.self).filter(predicate)
//    }
//
//    func getRecords(for habit: Habit) -> Results<Record> {
//        let realm = try! Realm()
//
//        let predicate = NSPredicate(format: "habit.id = %@", habit.id)
//        return realm.objects(Record.self).filter(predicate)
//    }
//
//    func getRecord(for habit: Habit, on date: Date) -> Record? {
//        let realm = try! Realm()
//
//        let dateString = dateFormatter.string(from: date)
//        let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", habit.id, dateString)
//        return realm.objects(Record.self).filter(predicate).first
//    }
//
//    func createRecord(habit: Habit, date: Date) {
//        let realm = try! Realm()
//
//        let newRecord = Record()
//        newRecord.habit = habit
//        newRecord.date = dateFormatter.string(from: date)
//
//        try! realm.write {
//            realm.add(newRecord)
//            realm.refresh()
//        }
//    }
//
//    func deleteRecord(for habit: Habit, on date: Date) {
//        let realm = try! Realm()
//
//        if let record = getRecord(for: habit, on: date) {
//            try! realm.write {
//                realm.delete(record)
//                realm.refresh()
//            }
//        }
//    }
//}
