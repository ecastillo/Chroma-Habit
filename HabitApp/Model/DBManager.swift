//
//  DBManager.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/16/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    static let shared = DBManager()
    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getHabits() -> List<Habit>? {
        //return realm.objects(Habit.self)
        return realm.objects(HabitList.self).first?.habits
    }
    
    func createHabit(name: String, color: UIColor) {
        let newHabit = Habit()
        newHabit.name = name
        newHabit.color = color.hexValue()
        
        let allHabits = getHabits()
        if let habits = allHabits {
            if habits.count > 0 {
                let maxOrder = habits.max(by: { $0.order > $1.order })?.order
                newHabit.order = maxOrder! + 1
            } else {
                newHabit.order = 0
            }
            
            let habitList = realm.objects(HabitList.self).first
            
            try! realm.write {
                //realm.add(newHabit)
                habitList?.habits.append(newHabit)
                realm.add(habitList!, update: true)
            }
        }
    }
    
    func deleteHabit(habit: Habit) {
        try! realm.write {
            let records = getRecords(for: habit)
            self.realm.delete(records)
            self.realm.delete(habit)
        }
    }
    
    func updateHabit(_ habit: Habit, name: String?, color: UIColor?) {
        try! realm.write {
            habit.name = name ?? habit.name
            habit.color = color?.hexValue() ?? habit.color
        }
    }
    
    func updateHabitOrder(from: Int, to: Int) {
        let habitList = realm.objects(HabitList.self).first
        
        try! realm.write {
            habitList?.habits.move(from: from, to: to)
            //realm.add(habitList!, update: true)
        }
    }
    
    func getRecords(on date: Date) -> Results<Record> {
        let dateString = dateFormatter.string(from: date)
        let predicate = NSPredicate(format: "date = %@", dateString)
        return realm.objects(Record.self).filter(predicate)
    }
    
    func getRecords(for habit: Habit) -> Results<Record> {
        let predicate = NSPredicate(format: "habit.id = %@", habit.id)
        return realm.objects(Record.self).filter(predicate)
    }
    
    func getRecord(for habit: Habit, on date: Date) -> Results<Record> {
        let dateString = dateFormatter.string(from: date)
        let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", habit.id, dateString)
        return realm.objects(Record.self).filter(predicate)
    }
    
    func createRecord(habit: Habit, date: Date) {
        let newRecord = Record()
        newRecord.habit = habit
        newRecord.date = dateFormatter.string(from: date)
        
        try! realm.write {
            realm.add(newRecord)
        }
    }
    
    func deleteRecord(for habit: Habit, on date: Date) {
        let record = getRecord(for: habit, on: date)
        try! realm.write {
            realm.delete(record)
        }
    }
}
