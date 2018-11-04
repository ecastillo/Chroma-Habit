//
//  TodayViewController.swift
//  Chroma Habit Widget
//
//  Created by Eric Castillo on 10/12/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import NotificationCenter
import  RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    var habits: Results<Habit>!
    var progressLayer = ProgressLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("widget loaded")
        
        habits = DBManager.shared.getHabits()
        
        print(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "")
        print(Realm.Configuration.defaultConfiguration.schemaVersion)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        completedLabel.text = "\(DBManager.shared.getRecords(on: Date()).count) of \(DBManager.shared.getHabits().count) habits completed today"
        
        //progressLayer.bounds = progressView.bounds
        
        progressLayer.orientation = .horizontal
        progressView.layer.addSublayer(progressLayer)
        
        loadProgress()
        
        //progressView.layoutIfNeeded()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: tableView.rowHeight*CGFloat(habits.count) + progressView.frame.height) : maxSize
        
        if expanded {
            completedLabel.isHidden = true
            tableView.isHidden = false
        } else {
            completedLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! WidgetTableViewCell
        cell.label.text = habits[indexPath.row].name
        if DBManager.shared.getRecord(for: habits[indexPath.row], on: Date()) != nil {
            cell.highlightNarrowWidthConstraint.isActive = false
            cell.label.textColor = UIColor.Theme.white
        } else {
            cell.highlightNarrowWidthConstraint.isActive = true
            cell.label.textColor = UIColor.Theme.black
        }
        cell.layoutIfNeeded()
        cell.highlight.backgroundColor = UIColor(hexString: habits[indexPath.row].color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WidgetTableViewCell
        let selectedHabit = habits[indexPath.row]
        
        UIView.animate(withDuration: 0.2) {
            if DBManager.shared.getRecord(for: selectedHabit, on: Date()) != nil {
                DBManager.shared.deleteRecord(for: selectedHabit, on: Date())
                cell.highlightNarrowWidthConstraint.isActive = true
                cell.label.textColor = UIColor.Theme.black
            } else {
                DBManager.shared.createRecord(habit: selectedHabit, date: Date())
                cell.highlightNarrowWidthConstraint.isActive = false
                cell.label.textColor = UIColor.Theme.white
            }
            cell.layoutIfNeeded()
        }
        
        loadProgress()
        
        completedLabel.text = "\(DBManager.shared.getRecords(on: Date()).count) of \(DBManager.shared.getHabits().count) habits completed today"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressLayer.frame = progressView.frame
        progressLayer.bounds = progressView.bounds
    }
    
    func loadProgress() {
        var progressColors = [UIColor]()
        for habit in habits {
            if DBManager.shared.getRecord(for: habit, on: Date()) != nil {
                progressColors.append(UIColor(hexString: habit.color))
            }
        }
        progressLayer.sliceColors = progressColors
    }
}
