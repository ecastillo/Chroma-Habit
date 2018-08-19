//
//  DrawerViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/10/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import RealmSwift
import Pulley

class DrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeDateDelegate, NewHabitDelegate, EditHabitDelegate {

    var selectedDate = Date()
    let realm = try! Realm()
    var habits: Results<Habit>?
    var pulleyViewController2: PulleyViewController?
    var delegate: HabitSelectedDelegate?
    var selectedHabit: Habit?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var drawerDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE, MMM d, yyyy"
        let date = dateFormatterGet.string(from: Date())
        drawerDateLabel.text = date
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleToolbarTap))
        toolbar.addGestureRecognizer(tap)
        toolbar.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pulleyViewController2 = parent as? PulleyViewController
        pulleyViewController2?.setDrawerPosition(position: .partiallyRevealed, animated: false)
        delegate = pulleyViewController2?.primaryContentViewController as? HabitSelectedDelegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let habits = realm.objects(Habit.self)
        //let habits = Database().getHabits()
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitsTableViewCell
        
        if let habit = habits?[indexPath.row] {
            //cell.textLabel?.text = habit.name
            cell.titleLabel.text = habit.name
            //cell.habitId = habit.id
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let date = dateFormatterGet.string(from: selectedDate)
            let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", habit.id, date)
            let record = realm.objects(Record.self).filter(predicate)
            //cell.accessoryType = record.count > 0 ? .checkmark : .none
            cell.done = record.count > 0 ? true : false
            if cell.done == true {
                cell.completedButton.setTitle("x", for: .normal)
            } else {
                cell.completedButton.setTitle("o", for: .normal)
            }
            //cell.backgroundColor = UIColor(hexString: habit.color)
            cell.titleView.backgroundColor = UIColor(hexString: habit.color)
            print((habits?[indexPath.row].id)!)
            print(Date() as CVarArg)
            
            cell.habit = habit
            cell.date = selectedDate
            cell.delegate = pulleyViewController2?.primaryContentViewController as? HabitCellDoneButtonTapped
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! HabitsTableViewCell
        print("selected cell's habit name: \(selectedCell.habit?.name)")
        selectedHabit = selectedCell.habit
        
        performSegue(withIdentifier: "editHabit", sender: self)
        
        selectedCell.setSelected(false, animated: true)
    }
    
    func loadData() {
        habits = realm.objects(Habit.self).sorted(byKeyPath: "name", ascending: true)
        //habits = Database().getHabits()
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newHabit" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! NewHabitViewController
            destinationVC.delegate = self
        } else if segue.identifier == "editHabit" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! NewHabitViewController
            destinationVC.delegate2 = self
            print("selected habit name: \(selectedHabit?.name)")
            destinationVC.habit = selectedHabit
        }
    }
    
    @IBAction func todayButtonTapped(_ sender: UIBarButtonItem) {
        print("today button tapped")
        let calendarViewController = pulleyViewController2?.primaryContentViewController as? CalendarViewController
        calendarViewController?.calendarView.scrollToHeaderForDate(Date(), triggerScrollToDateDelegate: false, withAnimation: true, extraAddedOffset: 0, completionHandler: nil)
    }
    
    @objc func handleToolbarTap(_ sender: UITapGestureRecognizer) {
        pulleyViewController2?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    func userSelectedANewDate(date: Date) {
        print("selected a date!")
        selectedDate = date
        loadData()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE, MMM d, yyyy"
        let datez = dateFormatterGet.string(from: selectedDate)
        drawerDateLabel.text = datez
    }
    
    func userCreatedANewHabit() {
        print("user created a new habit function!")
        loadData()
    }
    
    func userEditedAHabit() {
        print("user edited a habit function!")
        loadData()
        let calendarViewController = pulleyViewController2?.primaryContentViewController as? CalendarViewController
        calendarViewController?.calendarView.reloadData()
    }

}

protocol HabitSelectedDelegate {
    func userSelectedAHabit()
}
