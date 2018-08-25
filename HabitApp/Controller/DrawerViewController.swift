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
    var delegate: HabitSelectedDelegate?
    var selectedHabit: Habit?
    var calendarViewController: CalendarViewController?
    
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
        calendarViewController = pulleyViewController?.primaryContentViewController as? CalendarViewController
        
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: false)
        delegate = calendarViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let habits = DBManager.shared.getHabits()
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitsTableViewCell
        
        if let habit = habits?[indexPath.row] {
            cell.titleLabel.text = habit.name
            
            let record = DBManager.shared.getRecord(for: habit, on: selectedDate)
            cell.done = record.count > 0 ? true : false
            if cell.done == true {
                cell.completedButton.setTitle("x", for: .normal)
            } else {
                cell.completedButton.setTitle("o", for: .normal)
            }
            cell.titleView.backgroundColor = UIColor(hexString: habit.color)
            
            cell.habit = habit
            cell.date = selectedDate
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! HabitsTableViewCell
        selectedHabit = selectedCell.habit
        
        performSegue(withIdentifier: "editHabit", sender: self)
        
        selectedCell.setSelected(false, animated: true)
    }
    
    func loadData() {
        habits = DBManager.shared.getHabits().sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newHabit" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! NewHabitViewController
            destinationVC.newHabitDelegate = self
        } else if segue.identifier == "editHabit" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! NewHabitViewController
            destinationVC.editHabitDelegate = self
            destinationVC.habit = selectedHabit
        }
    }
    
    @IBAction func todayButtonTapped(_ sender: UIBarButtonItem) {
        print("today button tapped")
        calendarViewController?.calendarView.scrollToHeaderForDate(Date(), triggerScrollToDateDelegate: false, withAnimation: true, extraAddedOffset: 0, completionHandler: nil)
    }
    
    @objc func handleToolbarTap(_ sender: UITapGestureRecognizer) {
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
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
        calendarViewController?.calendarView.reloadData()
    }

}

extension DrawerViewController: HabitCellDoneButtonTapped {
    func userTappedCellDoneButton(cell: HabitsTableViewCell) {
        print("userTappedCellDoneButton")
        
        let selectedHabit = cell.habit
        
        cell.done = !cell.done
        
        if cell.done {
            DBManager.shared.createRecord(habit: selectedHabit!, date: selectedDate)
            cell.completedButton.titleLabel?.text = "x"
        } else {
            DBManager.shared.deleteRecord(for: selectedHabit!, on: selectedDate)
            cell.completedButton.titleLabel?.text = "o"
        }
        
        let calendarViewController = pulleyViewController?.primaryContentViewController as? CalendarViewController
        calendarViewController?.calendarView.reloadDates([selectedDate])
        
        loadData()
    }
}

protocol HabitSelectedDelegate {
    func userSelectedAHabit()
}
