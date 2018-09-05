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
import PopupDialog

protocol ChangeDateDelegate {
    func userSelectedANewDate(date: Date)
}

class CalendarViewController: UIViewController {
    var delegate: ChangeDateDelegate?

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    var selectedDate = Date()
    let todaysDate = Date()
    let realm = try! Realm()
    let red = UIColor.red
    let yellow = UIColor.yellow
    let white = UIColor.white
    let darkGray = UIColor.init(hexString: "767676")
    let black = UIColor.black
    var isInEditMode = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewTopConstraint: NSLayoutConstraint!
    
    
    let statusBarBackground = CAGradientLayer()
    let tableviewBgGradientLayer = CAGradientLayer()
    
    var popup: PopupDialog?
    
    //var selectedDate = Date()
    //let realm = try! Realm()
    var habits: List<Habit>?
    //var delegate: HabitSelectedDelegate?
    var selectedHabit: Habit?
    //var calendarViewController: CalendarViewController?
    
    @IBOutlet weak var tableView: myTableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var drawerDateLabel: UILabel!
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var editHabitsButton: UIButton!
    @IBOutlet weak var newHabitButton: UIButton!
    @IBOutlet weak var editingBgView: UIView!
    
    //@IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    //var defaultOffset: CGPoint?
    
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
                            self.tableView.contentInset = UIEdgeInsets(top: self.calendarView.frame.height-200, left: 0, bottom: 0, right: 0)
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
        
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        let buttonTwo = DefaultButton(title: "SAVE", dismissOnTap: false) {
            if !(popupViewController.nameTextField.text?.isEmpty)! {
                DBManager.shared.createHabit(name: popupViewController.nameTextField.text!, color: popupViewController.selectedColor!)
                
                self.userCreatedANewHabit()
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
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var oldContentOffset = CGPoint.zero
    var poop = CGSize.zero.height
    
//    var oldContentOffset = CGPoint.zero
//    let topConstraintRange = (CGFloat(120)..<CGFloat(300))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        let origImage = UIImage(named: "add")
//        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
//        newHabitButton.setImage(tintedImage, for: .normal)
       // newHabitButton.tintColor = .red
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //poop = heightConstraint.constant
        
        //tableView.contentInset = UIEdgeInsetsMake(calendarView.frame.size.height, 0, 0, 0)
        
        calendarView.scrollsToTop = false
     
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .none
        calendarView.cellSize = calendarView.frame.width/7
        //calendarView.allowsDateCellStretching = false
        calendarView.register(UINib(nibName: "MonthHeaderView", bundle: Bundle.main),
                          forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                          withReuseIdentifier: "MonthHeaderView")
        
        //calendarView.scrollToHeaderForDate(todaysDate)
        calendarView.scrollToDate(todaysDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .centeredVertically, extraAddedOffset: 0, completionHandler: nil)
        calendarView.selectDates([todaysDate])
        
       // calendarView.removeConstraint(a)
        
//        let a = NSLayoutConstraint(item: calendarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3000)
//
//        calendarView.addConstraint(a)
//
        
        
        
        
        loadData()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatterGet.string(from: Date())
        dateFormatterGet.dateFormat = "EEEE"
        weekdayLabel.text = dateFormatterGet.string(from: Date())
        
        
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleToolbarTap))
        //toolbar.addGestureRecognizer(tap)
        //toolbar.isUserInteractionEnabled = true
        
        
        
//        let bgView = UIView()
//        bgView.backgroundColor = UIColor(hexString: "FFFFFF", withAlpha: 0.7)
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//        daysStackView.insertSubview(bgView, at: 0)
//        NSLayoutConstraint.activate([
//            bgView.leadingAnchor.constraint(equalTo: daysStackView.leadingAnchor),
//            bgView.trailingAnchor.constraint(equalTo: daysStackView.trailingAnchor),
//            bgView.topAnchor.constraint(equalTo: daysStackView.topAnchor),
//            bgView.bottomAnchor.constraint(equalTo: daysStackView.bottomAnchor)
//            ])
        
        
        //gradientLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        tableviewBgGradientLayer.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor(white: 1, alpha: 0.9).cgColor]
        tableviewBgGradientLayer.locations = [0.0, 0.3]
        tableviewBgGradientLayer.frame = CGRect(x: -8, y: -50, width: view.frame.width, height: view.frame.height)
        tableView.layer.addSublayer(tableviewBgGradientLayer)
        tableviewBgGradientLayer.zPosition = -1
        
        
        
        //z.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        statusBarBackground.colors = [UIColor(white: 1, alpha: 0.8).cgColor, UIColor(white: 1, alpha: 0).cgColor]
        statusBarBackground.locations = [0.35, 1.0]
        
        view.layer.addSublayer(statusBarBackground)
        statusBarBackground.zPosition = 1
        
    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let highlightedCell = tableView.cellForRow(at: indexPath)
//        //highlightedCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//
//        UIView.animate(withDuration: 0.1,
//                       animations: {
//                        highlightedCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        })
//    }
//
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let highlightedCell = tableView.cellForRow(at: indexPath)
//        //highlightedCell?.transform = CGAffineTransform(scaleX: 1, y: 1)
//
//        UIView.animate(withDuration: 0.1,
//                       animations: {
//                        highlightedCell?.transform = CGAffineTransform(scaleX: 1, y: 1)
//        })
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let drawerContentVC = (self.parent as? PulleyViewController)?.drawerContentViewController
        delegate = drawerContentVC as? ChangeDateDelegate
        print("view will appear")
        
        //calendarViewController = pulleyViewController?.primaryContentViewController as? CalendarViewController
        
        //pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: false)
        //delegate = calendarViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //defaultOffset = tableView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset =  scrollView.contentOffset.y - oldContentOffset.y
        //print(contentOffset)
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        //if distanceFromBottom >= height {
        if !isInEditMode {
            calendarView.setContentOffset(CGPoint(x: 0, y: calendarView.contentOffset.y + contentOffset/2), animated: false)
        }
        //}
        
        //print(calendarView.contentOffset.y)
        
        if (scrollView.contentOffset.y < calendarView.frame.size.height * -1 ) {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: calendarView.frame.size.height * -1), animated: true)
        }
        
        oldContentOffset = scrollView.contentOffset
        
        if scrollView.contentOffset.y > 25 {
            //dateViewTopConstraint.constant = -scrollView.contentOffset.y - (dateView.frame.height - 10)
            //editButton2TopConstraint.constant = -scrollView.contentOffset.y - editButton2.frame.height - 10
            dateViewTopConstraint.constant = scrollView.contentOffset.y
        } else {
            //dateViewTopConstraint.constant = 0
            //editButton2TopConstraint.constant = 0
            dateViewTopConstraint.constant = 25
        }
        //print(scrollView.contentOffset.y)
        //view.layoutIfNeeded()
        
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
            tableView.contentInset = UIEdgeInsets(top: calendarView.frame.height-200, left: 0, bottom: 0, right: 0)
        }
        
        
        //print("did layout subviews")
        
        
        statusBarBackground.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.safeAreaInsets.top)
        //print("view safe area inset top: \(view.safeAreaInsets.top)")
    }
}

// MARK: - JTAppleCalendar

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2099 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 //generateInDates: .forFirstMonthOnly,
                                                 generateOutDates: .tillEndOfRow
                                                 //hasStrictBoundaries: false
        )
        
        return parameters
    }
    
    func configureCell(cell: JTAppleCell, cellState: CellState) {
        let customCell = cell as! CustomCell
        
        formatter.dateFormat = "yyyy MM dd"
        let a = formatter.string(from: todaysDate)
        let b = formatter.string(from: cellState.date)
//        //if Calendar.current.compare(cellState.date, to: todaysDate, toGranularity: .day) == .orderedSame {
//        if a == b {
//            customCell.backgroundColor = red
//        } else {
//            customCell.backgroundColor = white
//        }
        
        if a >= b {
            customCell.bgView.backgroundColor = UIColor(hexString: "E1E1E1")
        } else {
            customCell.bgView.backgroundColor = UIColor(hexString: "F3F3F3")
        }
        
        if cellState.dateBelongsTo == .thisMonth {
            customCell.isHidden = false
        } else {
            customCell.isHidden = true
        }
        customCell.dateLabel.text = cellState.text
        
        formatter.dateFormat = "MMM"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        //headerCell.title.text = formatter.string(from: date)
        let c = Calendar(identifier: .gregorian).component(.weekday, from: cellState.date)
        if c != 7 {
            customCell.border.isHidden = false
            customCell.border.frame = CGRect(x: customCell.frame.width - 2, y: 0, width: 2, height: customCell.frame.height)
            customCell.border.backgroundColor = UIColor.white.cgColor
        } else {
            customCell.border.isHidden = true
        }
    
        let completedRecords = DBManager.shared.getRecords(on: cellState.date)
        
        customCell.records = completedRecords
        
        if completedRecords.count > 0 {
            
            customCell.progressStackView.isHidden = false
            for v in customCell.progressStackView.arrangedSubviews {
                customCell.progressStackView.removeArrangedSubview(v)
            }
            
            for az in DBManager.shared.getHabits()! {
                for pp in completedRecords {
                    if az.id == pp.habit?.id {
                        let z = UIView()
                        for color in COLORS {
                            if color.hexValue() == pp.habit?.color {
                                z.backgroundColor = color
                            }
                        }
                        customCell.progressStackView.addArrangedSubview(z)
                    }
                }
            }
            
//            for section in 0...completedRecords.count-1 {
//                let z = UIView()
//                for color in COLORS {
//                    if color.hexValue() == completedRecords[section].habit?.color {
//                        z.backgroundColor = color
//                    }
//                }
//                customCell.progressStackView.addArrangedSubview(z)
//            }
            
            if cellState.isSelected {
                customCell.dateLabel.textColor = white
                customCell.dateView.backgroundColor = black
            } else {
                customCell.dateLabel.textColor = white
                customCell.dateView.backgroundColor = UIColor.clear
            }
        } else {
            customCell.progressStackView.isHidden = true
            
            if cellState.isSelected {
                customCell.dateLabel.textColor = white
                customCell.dateView.backgroundColor = black
            } else {
                customCell.dateLabel.textColor = darkGray
                customCell.dateView.backgroundColor = UIColor.clear
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
        guard let validCell = cell as? CustomCell else { return }
        
        if selectedDate != date {
            delegate?.userSelectedANewDate(date: date)
            
            configureCell(cell: validCell, cellState: cellState)
        }
        selectedDate = date
        
        userSelectedANewDate(date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        
        configureCell(cell: validCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let headerCell = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthHeaderView", for: indexPath) as! MonthHeaderView
        let date = range.start
        formatter.dateFormat = "MMM"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        //headerCell.title.text = formatter.string(from: date)
        let c = Calendar(identifier: .gregorian).component(.weekday, from: range.start)
        for (index, monthLabel) in headerCell.monthStackView.arrangedSubviews.enumerated() {
            let a = monthLabel as! UILabel
            if index == c-1 {
                a.text = formatter.string(from: date)
                a.alpha = 1
            } else {
                a.alpha = 0
            }
        }

        return headerCell
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
}

// MARK: - HabitSelectedDelegate

//extension CalendarViewController: HabitSelectedDelegate {
//    func userSelectedAHabit() {
//        calendarView.reloadDates([selectedDate])
//    }
//}













extension CalendarViewController: UITableViewDelegate, UITableViewDataSource, ChangeDateDelegate, NewHabitDelegate, EditHabitDelegate, HabitCellDoneButtonTapped, HabitCellDetailButtonTapped {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let habits = DBManager.shared.getHabits()
        return habits?.count ?? 0
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let verticalPadding: CGFloat = 10
//        let horizontalPadding: CGFloat = 30
//
//        let maskLayer = CALayer()
//        maskLayer.cornerRadius = 4    //if you want round edges
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
//        cell.contentView.layer.mask = maskLayer
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitsTableViewCell
        
        if let habit = habits?[indexPath.row] {
            cell.titleLabel.text = habit.name
            
            cell.backgroundColor = UIColor.clear //UIColor(hexString: habit.color)
            cell.xyz.backgroundColor = UIColor(hexString: habit.color)
            cell.xyz.color = UIColor(hexString: habit.color)!
            cell.highlight.backgroundColor = UIColor(hexString: habit.color)?.cgColor
            
            cell.bottomBorder.backgroundColor = UIColor(hexString: "EAEAEA")?.cgColor
            
            cell.tintColor = UIColor(hexString: habit.color)
            
            let record = DBManager.shared.getRecord(for: habit, on: selectedDate)
            cell.done = record.count > 0 ? true : false
            if cell.done == true {
                cell.checkmarkImageView.isHidden = false
                cell.highlight.frame.size.width = cell.frame.width
                
                cell.titleLabel.textColor = white
            } else {
                cell.checkmarkImageView.isHidden = true
                cell.highlight.frame.size.width = 5
                cell.highlight.transform = CATransform3DMakeScale(1, 1, 1.0)
                
                cell.titleLabel.textColor = black
            }
            cell.habit = habit
            cell.date = selectedDate
            cell.delegate = self
            cell.delegate2 = self
            
            cell.checkmarkView.layer.borderColor = UIColor(hexString: habit.color)?.cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! HabitsTableViewCell
        selectedHabit = selectedCell.habit
        
        if !tableView.isEditing {
            userTappedCellDoneButton(cell: tableView.cellForRow(at: indexPath) as! HabitsTableViewCell)

            selectedCell.setSelected(false, animated: true)
        } else {
        
            print("tapped cell in editing mode")
            //performSegue(withIdentifier: "editHabit", sender: selectedCell)
        
            let popupViewController = PopupViewController()
            popupViewController.habit = selectedHabit
            popup = PopupDialog(viewController: popupViewController, buttonAlignment: .vertical, transitionStyle: .bounceUp, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
            
            let buttonOne = CancelButton(title: "CANCEL") {
                print("You canceled the car dialog.")
            }
            
            let buttonTwo = DefaultButton(title: "SAVE") {
                DBManager.shared.updateHabit(self.selectedHabit!, name: popupViewController.nameTextField.text!, color: popupViewController.selectedColor)
                
                self.userEditedAHabit()
            }
            
            let buttonThree = DefaultButton(title: "DELETE", dismissOnTap: true) {
                let alert = UIAlertController(title: "Delete \((self.selectedHabit?.name)!)?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                let action = UIAlertAction(title: "Delete", style: .default) { (action) in
                    DBManager.shared.deleteHabit(habit: self.selectedHabit!)
                    self.userEditedAHabit()
                    self.popup?.dismiss()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            buttonThree.tintColor = UIColor.red

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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        DBManager.shared.updateHabitOrder(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func loadData() {
        habits = DBManager.shared.getHabits()
        if habits != nil {
            habits!.sorted(byKeyPath: "name", ascending: true)
        }
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newHabit" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! NewHabitViewController
            destinationVC.newHabitDelegate = self
        } else if segue.identifier == "editHabit" {
            //let nav = segue.destination as! UINavigationController
            let destinationVC = segue.destination as! NewHabitViewController
            destinationVC.editHabitDelegate = self
            destinationVC.habit = selectedHabit
            destinationVC.title = selectedHabit?.name
        }
    }
    
    @IBAction func todayButtonTapped(_ sender: UIBarButtonItem) {
        print("today button tapped")
        //calendarViewController?.calendarView.scrollToHeaderForDate(Date(), triggerScrollToDateDelegate: false, withAnimation: true, extraAddedOffset: 0, completionHandler: nil)
        let offset = -tableView.contentOffset.y/2
        print(tableView.contentOffset.y/2)
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: true, preferredScrollPosition: .top, extraAddedOffset: 0, completionHandler: { () in
            self.calendarView.setContentOffset(CGPoint(x: 0, y: self.calendarView.contentOffset.y - offset), animated: true)
        })
        calendarView.selectDates([Date()])
    }
    
    @objc func handleToolbarTap(_ sender: UITapGestureRecognizer) {
        pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    func userSelectedANewDate(date: Date) {
        print("selected a date!")
        selectedDate = date
        loadData()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatterGet.string(from: selectedDate)
        dateFormatterGet.dateFormat = "EEEE"
        weekdayLabel.text = dateFormatterGet.string(from: selectedDate)
    }
    
    func userCreatedANewHabit() {
        print("user created a new habit function!")
        loadData()
    }
    
    func userEditedAHabit() {
        print("user edited a habit function!")
        loadData()
        calendarView.reloadData()
    }
    
    func userTappedCellDoneButton(cell: HabitsTableViewCell) {
        print("userTappedCellDoneButton")
        
        let selectedHabit = cell.habit
        
        cell.done = !cell.done
        
        if cell.done {
            DBManager.shared.createRecord(habit: selectedHabit!, date: selectedDate)
            //cell.completedButton.titleLabel?.text = "x"
        } else {
            DBManager.shared.deleteRecord(for: selectedHabit!, on: selectedDate)
            //cell.completedButton.titleLabel?.text = "o"
        }
        
        calendarView.reloadDates([selectedDate])
        
        loadData()
    }
    
    func userTappedCellDetailButton(cell: HabitsTableViewCell) {
        print("heyyyyy")
        selectedHabit = cell.habit
        
        //performSegue(withIdentifier: "editHabit", sender: self)
    }
}
