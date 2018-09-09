//
//  CalendarCell.swift
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

class CalendarCell: JTAppleCell {
    var records: Results<Record>?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var progressStackViewContainer: UIView!
    
    var border = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        border.frame = CGRect(x: frame.width - 2, y: 0, width: 2, height: frame.height)
        border.backgroundColor = UIColor.Theme.white.cgColor
    }

}
