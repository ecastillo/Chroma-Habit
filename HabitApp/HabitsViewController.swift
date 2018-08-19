//
//  HabitsViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import RealmSwift

class HabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewHabitDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var habits: Results<Habit>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //let record1 = Record()
        
        //if let habit = habit1 {
//            do {
//                try self.realm.write {
//                    let newRecord = Record()
//                    newRecord.date = Date()
//                    habit1.records.append(newRecord)
//                }
//            } catch {
//                print("Error saving new item: \(error)")
//            }
       // }
        
        loadData()
        
        //let predicate = NSPredicate(format: "date = %@ AND habit.id = %@", "tan", 1)
        let predicate = NSPredicate(format: "habit.id = %@", "0297DA6D-7371-481E-93BD-EF5E9390A5D1")
        let records = realm.objects(Record.self).filter(predicate)
        print(records.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitsTableViewCell
        if let habit = habits?[indexPath.row] {
            cell.textLabel?.text = habit.name
            //cell.habitId = habit.id
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let today = dateFormatterGet.string(from: Date())
            let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", (habits?[indexPath.row].id)!, today)
            let record = realm.objects(Record.self).filter(predicate)
            cell.accessoryType = record.count > 0 ? .checkmark : .none
            print((habits?[indexPath.row].id)!)
            print(Date() as CVarArg)
        }
        return cell
    }
    
    func userCreatedANewHabit() {
        print("user created a new habit function!")
        loadData()
    }
    
    func loadData() {
        habits = realm.objects(Habit.self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewHabit" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! NewHabitViewController
            destinationVC.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! HabitsTableViewCell
        
        let selectedHabit = habits?[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let today = dateFormatterGet.string(from: Date())
        
        if selectedCell.done {
            let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", (selectedHabit?.id)!, today)
            let record = realm.objects(Record.self).filter(predicate)
            try! realm.write {
                realm.delete(record)
            }
        } else {
            let newRecord = Record()
            newRecord.habit = selectedHabit
            newRecord.date = today
            
            try! realm.write {
                realm.add(newRecord)
            }
        }
        
        selectedCell.done = !selectedCell.done
        
        loadData()
    }

}
