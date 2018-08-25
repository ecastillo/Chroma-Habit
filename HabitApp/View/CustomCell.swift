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
    var records: Results<Record>?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var progressView: MGSegmentedProgressBar?
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dateView: UIView!
    
    //var progressView: MGSegmentedProgressBar?
}

extension CustomCell: MGSegmentedProgressBarDataSource {
    func progressBar(_ progressBar: MGSegmentedProgressBar, barForSection section: Int) -> MGBarView {
        let bar =  MGBarView()
        
        if records?.isEmpty == false {
            for color in COLORS {
                if color.hexValue() == records![section].habit?.color {
                    bar.backgroundColor = color
                }
            }
           // bar.backgroundColor = UIColor(hexString: (records![section].habit?.color)!)
        }

        return bar
    }
    
    func numberOfSteps(in progressBar: MGSegmentedProgressBar) -> Int {
        return records?.count ?? 0
    }
    
    func numberOfSections(in progressBar: MGSegmentedProgressBar) -> Int {
        return records?.count ?? 0
    }
}
