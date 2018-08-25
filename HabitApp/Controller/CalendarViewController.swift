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
    let darkGray = UIColor.init(hexString: "4F4F4F")
    let black = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        calendarView.scrollsToTop = false
     
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .none
        calendarView.cellSize = calendarView.frame.width/7
        //calendarView.allowsDateCellStretching = false
        calendarView.register(UINib(nibName: "MonthHeaderView", bundle: Bundle.main),
                          forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                          withReuseIdentifier: "MonthHeaderView")
        
        calendarView.scrollToHeaderForDate(todaysDate)
        calendarView.selectDates([todaysDate])
        
       // calendarView.removeConstraint(a)
        
        let a = NSLayoutConstraint(item: calendarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3000)
        
        calendarView.addConstraint(a)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let drawerContentVC = (self.parent as? PulleyViewController)?.drawerContentViewController
        delegate = drawerContentVC as? ChangeDateDelegate
        print("view will appear")
        
//        calendarView.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height))
    }
}

// MARK: - JTAppleCalendar

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
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
        formatter.dateFormat = "yyyy MM dd"
        let a = formatter.string(from: todaysDate)
        let b = formatter.string(from: cellState.date)
        let customCell = cell as! CustomCell
        //if Calendar.current.compare(cellState.date, to: todaysDate, toGranularity: .day) == .orderedSame {
        if a == b {
            customCell.backgroundColor = red
        } else {
            customCell.backgroundColor = white
        }
        customCell.selectedView.isHidden = true
        if cellState.isSelected {
            customCell.dateLabel.textColor = white
            customCell.dateLabel.backgroundColor = black
           // customCell.selectedView.isHidden = false
        } else {
            customCell.dateLabel.textColor = darkGray
            customCell.dateLabel.backgroundColor = white
           // customCell.selectedView.isHidden = true
        }
        if cellState.dateBelongsTo == .thisMonth {
            customCell.isHidden = false
        } else {
            customCell.isHidden = true
        }
        customCell.dateLabel.text = cellState.text
        
        customCell.bgView.layer.cornerRadius = 6
        
        customCell.shadowView.layer.shadowColor = UIColor.black.cgColor
        customCell.shadowView.layer.shadowOpacity = 0.17
        customCell.shadowView.layer.shadowOffset = CGSize.zero
        customCell.shadowView.layer.shadowRadius = 5/2
        customCell.shadowView.layer.shadowPath = UIBezierPath(roundedRect: customCell.shadowView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6)).cgPath
        
        customCell.dateView.layer.cornerRadius = customCell.dateView.frame.width/2

        customCell.dateView.layer.shadowColor = UIColor.black.cgColor
        customCell.dateView.layer.shadowOpacity = 0.13
        customCell.dateView.layer.shadowOffset = CGSize.zero
        customCell.dateView.layer.shadowRadius = 5/2
        customCell.dateView.layer.shadowPath = UIBezierPath(roundedRect: customCell.dateView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: customCell.dateView.bounds.width/2, height: customCell.dateView.bounds.height/2)).cgPath
        
        
        customCell.dateLabel.layer.cornerRadius = customCell.dateLabel.frame.width/2
        
        //customCell.dateView.layer.masksToBounds = false

    
        let completedRecords = DBManager.shared.getRecords(on: cellState.date).sorted(byKeyPath: "habit.name")
        
        customCell.records = completedRecords
        
        if completedRecords.count > 0 {
            if customCell.progressView == nil {
                print("wtf")
                customCell.progressView = MGSegmentedProgressBar(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
                //customCell.progressView?.backgroundColor = UIColor.black
                customCell.addSubview(customCell.progressView!)
            }
            
            customCell.progressView?.lineCap = .butt
            //customCell.progressView?.
            customCell.progressView?.transform = CGAffineTransform(rotationAngle: .pi/2)
            customCell.progressView?.dataSource = customCell
            
            for section in 0...completedRecords.count-1 {
                customCell.progressView?.setProgress(section: section, steps: 1)
            }
            
            customCell.progressView?.isHidden = false
        } else {
            customCell.progressView?.isHidden = true
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
        selectedDate = date
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
        return MonthSize(defaultSize: 25)
    }
}

// MARK: - HabitSelectedDelegate

extension CalendarViewController: HabitSelectedDelegate {
    func userSelectedAHabit() {
        calendarView.reloadDates([selectedDate])
    }
}
