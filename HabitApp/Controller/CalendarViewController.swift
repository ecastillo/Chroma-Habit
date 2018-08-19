//
//  CalendarViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift
import Pulley
import MGSegmentedProgressBar

//Write the protocol declaration here:
protocol ChangeDateDelegate {
    func userSelectedANewDate(date: Date)
}

class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    //Declare the delegate variable here:
    var delegate: ChangeDateDelegate?

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    //@IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    var selectedDate = Date()
    let todaysDate = Date()
    let realm = try! Realm()
    
    let numOfSections = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollsToTop = false
     
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .none
        calendarView.cellSize = 60
        print("calendar content size: \(calendarView.frame.width)")
        calendarView.register(UINib(nibName: "MonthHeaderView", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                              withReuseIdentifier: "MonthHeaderView")
        
        //calendarView.scrollToDate(Date(), animateScroll: false)
        
        //var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        //component.day = 1
       // let firstDayOfCurrentMonth = Calendar.current.date(from: component)!
       // calendarView.scrollToDate(firstDayOfCurrentMonth, animateScroll: false)
        calendarView.scrollToHeaderForDate(Date())
        calendarView.selectDates([Date()])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let drawerContentVC = (self.parent as? PulleyViewController)?.drawerContentViewController
        delegate = drawerContentVC as? ChangeDateDelegate
        print("view will appear")
    }
    
    
    
    

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 generateOutDates: .tillEndOfRow)
        return parameters
    }
    
    func configureCell(cell: JTAppleCell, cellState: CellState) {
        let customCell = cell as! CustomCell
        if Calendar.current.compare(cellState.date, to: todaysDate, toGranularity: .day) == .orderedSame {
            customCell.backgroundColor = UIColor.red
        } else {
            customCell.backgroundColor = UIColor.yellow
        }
        if cellState.isSelected {
            customCell.dateLabel.textColor = UIColor.white
            customCell.selectedView.isHidden = false
        } else {
            customCell.dateLabel.textColor = UIColor.blue
            customCell.selectedView.isHidden = true
        }
        if cellState.dateBelongsTo == .thisMonth {
            customCell.isHidden = false
        } else {
            customCell.isHidden = true
        }
        customCell.dateLabel.text = cellState.text
        
        let completedHabits = habitsCompleted(on: cellState.date)
        
        customCell.numOfSections = completedHabits.count
        
        customCell.completedHabits = completedHabits
        
        customCell.progressView.dataSource = customCell
        customCell.progressView.lineCap = .square
        customCell.progressView.transform = CGAffineTransform(rotationAngle: -.pi/2);
        
        if completedHabits.count > 0 {
            for section in 0...completedHabits.count-1 {
                customCell.progressView.setProgress(section: section, steps: 1)
            }
        }
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        configureCell(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let customCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        self.calendar(calendar, willDisplay: customCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return customCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print(date)
        selectedDate = date
        //tableView.reloadData()
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userSelectedANewDate(date: date)
        
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = false
        
        configureCell(cell: validCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = true
        
        configureCell(cell: validCell, cellState: cellState)
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let headerCell = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthHeaderView", for: indexPath) as! MonthHeaderView
        let date = range.start
        formatter.dateFormat = "MMM"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        headerCell.title.text = formatter.string(from: date)
        return headerCell
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
    func habitsCompleted(on: Date) -> [Habit] {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let date = dateFormatterGet.string(from: on)
        let predicate = NSPredicate(format: "date = %@", date)
        let records = realm.objects(Record.self).filter(predicate)
        var habits = [Habit]()
        for record in records {
            if let habit = record.habit {
                habits.append(habit)
            }
        }
        habits = habits.sorted(by: { $0.name > $1.name })
        return habits
    }

}

extension CalendarViewController: HabitSelectedDelegate {
    func userSelectedAHabit() {
        calendarView.reloadDates([selectedDate])
    }
}

extension CalendarViewController: HabitCellDoneButtonTapped {
    func userTappedCellDoneButton(cell: HabitsTableViewCell) {
        print("userTappedCellDoneButton")
        
        let selectedHabit = cell.habit
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let date = dateFormatterGet.string(from: selectedDate)
        
        if cell.done {
            let predicate = NSPredicate(format: "habit.id = %@ AND date = %@", (selectedHabit?.id)!, date)
            let record = realm.objects(Record.self).filter(predicate)
            try! realm.write {
                realm.delete(record)
            }
            cell.completedButton.titleLabel?.text = "o"
        } else {
            let newRecord = Record()
            newRecord.habit = selectedHabit
            newRecord.date = date
            
            try! realm.write {
                realm.add(newRecord)
            }
            cell.completedButton.titleLabel?.text = "x"
        }
        
        cell.done = !cell.done
        
        calendarView.reloadDates([selectedDate])
        
        let drawerViewController = pulleyViewController?.drawerContentViewController as? DrawerViewController
        drawerViewController?.loadData()
    }
    

}
