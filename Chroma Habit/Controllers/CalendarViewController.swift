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
import PopupDialog
import Onboard

class CalendarViewController: UIViewController {

    let dateFormatter = DateFormatter()
    var selectedDate = Date()
    let todaysDate = Date()
    let realm = try! Realm()
    var isInEditMode = false
    let statusBarBackground = CAGradientLayer()
    let tableviewBgGradientLayer = CAGradientLayer()
    var popup: PopupDialog?
    var habits: Results<Habit>!
    var habitColors = [String: UIColor]()
    var selectedHabit: Habit?
    
    var onboardingVC = OnboardingViewController()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: HabitsTableView!
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var editHabitsButton: UIButton!
    @IBOutlet weak var newHabitButton: UIButton!
    @IBOutlet weak var editingBgView: UIView!
    
    var oldContentOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        editHabitsButton.backgroundColor = UIColor.white
        editHabitsButton.tintColor = UIColor.flatBlue
        editHabitsButton.setImage(editHabitsButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        editHabitsButton.layer.cornerRadius = editHabitsButton.frame.width/2
        editHabitsButton.layer.shadowColor = UIColor.black.cgColor
        editHabitsButton.layer.shadowRadius = 4
        editHabitsButton.layer.shadowOpacity = 0.3
        editHabitsButton.layer.shadowOffset = CGSize.zero
        
        newHabitButton.backgroundColor = UIColor.white
        newHabitButton.tintColor = UIColor.flatBlue
        newHabitButton.setImage(newHabitButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        newHabitButton.layer.cornerRadius = newHabitButton.frame.width/2
        newHabitButton.layer.shadowColor = UIColor.black.cgColor
        newHabitButton.layer.shadowRadius = 4
        newHabitButton.layer.shadowOpacity = 0.3
        newHabitButton.layer.shadowOffset = CGSize.zero
        
        dateView.layer.cornerRadius = 4
        
        calendarView.scrollsToTop = false
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .none
        calendarView.cellSize = calendarView.frame.width/7
        calendarView.register(UINib(nibName: "MonthHeaderView", bundle: Bundle.main),
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: "MonthHeaderView")
        
        //calendarView.scrollToHeaderForDate(todaysDate)
        calendarView.scrollToDate(todaysDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .centeredVertically, extraAddedOffset: 0, completionHandler: nil)
        calendarView.selectDates([todaysDate])

        // Date view for habits table
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "EEEE"
        weekdayLabel.text = dateFormatter.string(from: Date())
        
        // Gradient behind habits table
        tableviewBgGradientLayer.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor(white: 1, alpha: 0.9).cgColor]
        tableviewBgGradientLayer.locations = [0.0, 0.3]
        tableviewBgGradientLayer.frame = CGRect(x: -8, y: -50, width: view.frame.width, height: view.frame.height)
        tableView.layer.addSublayer(tableviewBgGradientLayer)
        tableviewBgGradientLayer.zPosition = -1
        
        // Gradient behind status bar
        statusBarBackground.colors = [UIColor(white: 1, alpha: 0.8).cgColor, UIColor(white: 1, alpha: 0).cgColor]
        statusBarBackground.locations = [0.35, 1.0]
        statusBarBackground.zPosition = 1
        view.layer.addSublayer(statusBarBackground)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset =  scrollView.contentOffset.y - oldContentOffset.y
        if !isInEditMode {
            calendarView.setContentOffset(CGPoint(x: 0, y: calendarView.contentOffset.y + contentOffset/2), animated: false)
        }
        
        if (scrollView.contentOffset.y < calendarView.frame.size.height * -1 ) {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: calendarView.frame.size.height * -1), animated: true)
        }
        
        oldContentOffset = scrollView.contentOffset
        
        if scrollView.contentOffset.y + view.safeAreaInsets.top > 25 {
            dateViewTopConstraint.constant = scrollView.contentOffset.y + view.safeAreaInsets.top
        } else {
            dateViewTopConstraint.constant = 25
        }
        
        if scrollView.contentOffset.y > 0 {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            tableviewBgGradientLayer.frame.origin.y = scrollView.contentOffset.y
            CATransaction.commit()
        } else {
            tableviewBgGradientLayer.frame.origin.y = -50
        }
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isInEditMode {
            
            //tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
            
            let a = (2/3)*view.frame.height
            if tableView.contentSize.height < (1/3)*view.frame.height {
                tableView.contentInset = UIEdgeInsets(top: a, left: 0, bottom: 0, right: 0)
                print("contentSize.height in viewDidLayoutSubviews: \(self.tableView.contentSize.height)")
            } else {
                tableView.contentInset = UIEdgeInsets(top: a, left: 0, bottom: 0, right: 0)
            }
            
            
//            if tableView.contentSize.height < 250 {
//                tableView.contentInset = UIEdgeInsets(top: calendarView.frame.height-tableView.contentSize.height-view.safeAreaInsets.bottom-25, left: 0, bottom: 0, right: 0)
//            } else {
//                tableView.contentInset = UIEdgeInsets(top: calendarView.frame.height-250, left: 0, bottom: 0, right: 0)
//            }
        }
        
        statusBarBackground.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.safeAreaInsets.top)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            isInEditMode = true
            UIView.animate(withDuration: 0.4,
                           animations: {
                            self.tableView.contentInset.top = 0
                            self.dateView.alpha = 0
                            self.editingBgView.alpha = 1
                            self.editHabitsButton.backgroundColor = UIColor.flatBlue
                            self.editHabitsButton.tintColor = UIColor.white
                            self.newHabitButton.alpha = 0
            })
        } else {
            calendarView.reloadData()
            UIView.animate(withDuration: 0.4,
                           animations: {
                            let a = (2/3)*self.view.frame.height
                            if self.tableView.contentSize.height < (1/3)*self.view.frame.height {
                                self.tableView.contentInset = UIEdgeInsets(top: a, left: 0, bottom: 0, right: 0)
                                print("contentSize.height in editing animation: \(self.tableView.contentSize.height)")
                            } else {
                                self.tableView.contentInset = UIEdgeInsets(top: a, left: 0, bottom: 0, right: 0)
                            }
                            //self.tableView.contentInset = UIEdgeInsets(top: self.calendarView.frame.height-200, left: 0, bottom: 0, right: 0)
                            self.dateView.alpha = 1
                            self.editingBgView.alpha = 0
                            self.editHabitsButton.backgroundColor = UIColor.white
                            self.editHabitsButton.tintColor = UIColor.flatBlue
                            self.newHabitButton.alpha = 1
            }) { (finished) in
                self.isInEditMode = false
            }
        }
    }
    
    @IBAction func newHabitButtonTapped(_ sender: UIButton) {
        let popupViewController = PopupViewController()
        popup = PopupDialog(viewController: popupViewController, buttonAlignment: .vertical, transitionStyle: .bounceUp, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
        
        let buttonOne = CancelButton(title: "CANCEL") {}
        
        let buttonTwo = DefaultButton(title: "SAVE", dismissOnTap: false) {
            if !(popupViewController.nameTextField.text?.isEmpty)! {
                DBManager.shared.createHabit(name: popupViewController.nameTextField.text!, color: popupViewController.selectedColor!)
                self.loadData()
                self.tableView.reloadData()
                self.popup?.dismiss()
            } else {
                self.popup?.shake()
            }
        }
        
        popup?.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        DispatchQueue.main.async {
            self.present(self.popup!, animated: true, completion: nil)
        }
    }
}


// MARK: - JTAppleCalendar Delegate & Datasource

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2018 01 01")!
        let endDate = dateFormatter.date(from: "2099 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 generateOutDates: .tillEndOfRow
        )
        
        return parameters
    }
    
    func configureCell(cell: JTAppleCell, cellState: CellState) {
        let calendarCell = cell as! CalendarCell
        
        dateFormatter.dateFormat = "yyyy MM dd"
        let todaysDateString = dateFormatter.string(from: todaysDate)
        let cellDateString = dateFormatter.string(from: cellState.date)
        calendarCell.bgView.backgroundColor = (todaysDateString >= cellDateString) ? UIColor.Theme.mediumGray : UIColor.Theme.lightGray
        
//        //if Calendar.current.compare(cellState.date, to: todaysDate, toGranularity: .day) == .orderedSame {
//        if todaysDateString == cellDateString {
//            calendarCell.backgroundColor = red
//        } else {
//            calendarCell.backgroundColor = white
//        }

        calendarCell.isHidden = cellState.dateBelongsTo != .thisMonth
        calendarCell.dateLabel.text = cellState.text
        
        let dayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: cellState.date)
        calendarCell.border.isHidden = dayOfWeek == 7
    
        let completedRecords = DBManager.shared.getRecords(on: cellState.date).sorted(byKeyPath: "habit.order")
        
        calendarCell.records = completedRecords
        
        if completedRecords.count > 0 {
            print("has completed records")
            calendarCell.progressStackView.isHidden = false
            calendarCell.progressStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            
            for record in completedRecords {
                let recordProgress = UIView()
                recordProgress.backgroundColor = habitColors[(record.habit?.id)!]
                calendarCell.progressStackView.addArrangedSubview(recordProgress)
            }
            
            if cellState.isSelected {
                calendarCell.dateLabel.textColor = UIColor.Theme.white
                calendarCell.dateView.backgroundColor = UIColor.Theme.black
            } else {
                calendarCell.dateLabel.textColor = UIColor.Theme.white
                calendarCell.dateView.backgroundColor = UIColor.Theme.clear
            }
        } else {
            calendarCell.progressStackView.isHidden = true
            
            if cellState.isSelected {
                calendarCell.dateLabel.textColor = UIColor.Theme.white
                calendarCell.dateView.backgroundColor = UIColor.Theme.black
            } else {
                calendarCell.dateLabel.textColor = UIColor.Theme.darkGray
                calendarCell.dateView.backgroundColor = UIColor.Theme.clear
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let calendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: calendarCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return calendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        
        if selectedDate != date {
            selectedDate = date
            tableView.reloadData()
            
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateLabel.text = dateFormatter.string(from: selectedDate)
            dateFormatter.dateFormat = "EEEE"
            weekdayLabel.text = dateFormatter.string(from: selectedDate)
            
            configureCell(cell: validCell, cellState: cellState)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        
        configureCell(cell: validCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthHeaderView", for: indexPath) as! MonthHeaderView
        let date = range.start
        dateFormatter.dateFormat = "MMM"
        let dayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: range.start)
        for case let (index, monthLabel as UILabel) in headerView.monthStackView.arrangedSubviews.enumerated() {
            if index == dayOfWeek-1 {
                monthLabel.alpha = 1
                monthLabel.text = dateFormatter.string(from: date)
            } else {
                monthLabel.alpha = 0
            }
        }
        
        let month = Calendar(identifier: .gregorian).component(.month, from: range.start)
        if month == 1 {
            headerView.frame.size.height = 59
            headerView.yearLabel.isHidden = false
            headerView.yearLabel.text = String(Calendar(identifier: .gregorian).component(.year, from: range.start))
        } else {
            headerView.frame.size.height = 40
            headerView.yearLabel.isHidden = true
        }
    
        return headerView
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40, months: [59 : [.jan]], dates: nil)
    }

}







// MARK: - UITableView Delegate & Datasource

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let habits = DBManager.shared.getHabits()
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let habitCell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitsTableViewCell
        
        if let habit = habits?[indexPath.row] {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            habitCell.titleLabel.text = habit.name
            habitCell.reorderBackgroundView.color = UIColor(hexString: habit.color)!
            habitCell.highlight.backgroundColor = UIColor(hexString: habit.color)?.cgColor
            habitCell.tintColor = UIColor(hexString: habit.color)
            habitCell.checkmarkView.layer.borderColor = UIColor(hexString: habit.color)?.cgColor
            
            habitCell.setDone((DBManager.shared.getRecord(for: habit, on: selectedDate) != nil), animated: false)
            
            CATransaction.commit()
        }
        return habitCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! HabitsTableViewCell
        selectedHabit = habits?[indexPath.row]
        
        if !tableView.isEditing {
            selectedCell.setDone(!selectedCell.done, animated: true)
            
            if selectedCell.done {
                DBManager.shared.createRecord(habit: selectedHabit!, date: selectedDate)
            } else {
                DBManager.shared.deleteRecord(for: selectedHabit!, on: selectedDate)
            }
            
            calendarView.reloadDates([selectedDate])
            
            selectedCell.setSelected(false, animated: true)
        } else {
            let popupViewController = PopupViewController()
            popupViewController.habit = selectedHabit
            popup = PopupDialog(viewController: popupViewController, buttonAlignment: .vertical, transitionStyle: .bounceUp, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
            
            let buttonOne = CancelButton(title: "CANCEL"){}
            
            let buttonTwo = DefaultButton(title: "SAVE") {
                DBManager.shared.updateHabit(self.selectedHabit!, name: popupViewController.nameTextField.text!, color: popupViewController.selectedColor)
                self.userEditedAHabit()
            }
            
            let buttonThree = DefaultButton(title: "DELETE", dismissOnTap: true) {
                let alert = UIAlertController(title: "Delete \((self.selectedHabit?.name)!)?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                let action = UIAlertAction(title: "Delete", style: .default) { (action) in
                    DBManager.shared.deleteHabit(habit: self.selectedHabit!)
                    self.userEditedAHabit()
                    self.popup?.dismiss()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

            popup?.addButtons([buttonOne, buttonTwo, buttonThree])
            
            // Present dialog
            DispatchQueue.main.async {
                self.present(self.popup!, animated: true, completion: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        DBManager.shared.updateHabitOrder(from: habits![sourceIndexPath.row].order, to: habits![destinationIndexPath.row].order)
        habits = DBManager.shared.getHabits()
        loadData()
        // TODO: only refresh data for selected date
    }
    
    func loadData() {
        habits = DBManager.shared.getHabits()
        for habit in habits {
            habitColors[habit.id] = UIColor(hexString: habit.color)
        }
    }
    
//    @IBAction func todayButtonTapped(_ sender: UIBarButtonItem) {
//        print("today button tapped")
//        //calendarViewController?.calendarView.scrollToHeaderForDate(Date(), triggerScrollToDateDelegate: false, withAnimation: true, extraAddedOffset: 0, completionHandler: nil)
//        let offset = -tableView.contentOffset.y/2
//        print(tableView.contentOffset.y/2)
//        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: true, preferredScrollPosition: .top, extraAddedOffset: 0, completionHandler: { () in
//            self.calendarView.setContentOffset(CGPoint(x: 0, y: self.calendarView.contentOffset.y - offset), animated: true)
//        })
//        calendarView.selectDates([Date()])
//    }
    
    func userEditedAHabit() {
        loadData()
        calendarView.reloadData()
        tableView.reloadData()
    }
}
