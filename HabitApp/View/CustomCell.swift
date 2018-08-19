//
//  CustomCell.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import JTAppleCalendar
import MGSegmentedProgressBar
import ChameleonFramework
import RealmSwift

class CustomCell: JTAppleCell {
    var numOfSections = 0
    var completedHabits: [Habit]?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var progressView: MGSegmentedProgressBar!
}

extension CustomCell: MGSegmentedProgressBarDataSource {
    func progressBar(_ progressBar: MGSegmentedProgressBar, barForSection section: Int) -> MGBarView {
        let bar =  MGBarView()

        if let aaa = completedHabits {
            if aaa.count > 0 {
                bar.backgroundColor = UIColor(hexString: aaa[section].color)
            }
        }

        return bar
    }
    
    func numberOfSteps(in progressBar: MGSegmentedProgressBar) -> Int {
        return completedHabits?.count ?? 0
    }
    
    func numberOfSections(in progressBar: MGSegmentedProgressBar) -> Int {
        return completedHabits?.count ?? 0
    }
}
