//
//  ViewController.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/19/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell2", for: indexPath) as! CustomCell2
        cell.dateLabel.text = cellState.text
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2018 01 01")
        let endDate = formatter.date(from: "2018 12 31")
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!, generateOutDates: .tillEndOfRow)
        calendar.register(UINib(nibName: "MonthHeaderView", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                              withReuseIdentifier: "MonthHeaderView")
        calendar.scrollDirection = .vertical
        calendar.scrollingMode = .none
        calendar.cellSize = 60
        //calendar.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        calendar.scrollToHeaderForDate(Date())
        return parameters
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
}
