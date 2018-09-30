//
//  CalendarCell.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/6/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import JTAppleCalendar
import ChameleonFramework
import RealmSwift

class CalendarCell: JTAppleCell {
    var records: Results<Record>?

    var progressContainerLayer = CAShapeLayer()
    var border = CALayer()
    let dateText = CATextLayer()
    let dateBg = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressContainerLayer.isOpaque = true
        progressContainerLayer.drawsAsynchronously = true
        
        layer.addSublayer(progressContainerLayer)
        layer.addSublayer(border)
        layer.addSublayer(dateBg)
        dateBg.addSublayer(dateText)
    }
    
    override func layoutSubviews() {
        progressContainerLayer.frame = layer.bounds
        progressContainerLayer.zPosition = -1
        
        border.frame = CGRect(x: frame.width - 2, y: 0, width: 2, height: frame.height)
        border.backgroundColor = UIColor.Theme.white.cgColor
        
        dateText.frame = CGRect(origin: CGPoint(x: 3, y: 0), size: CGSize(width: 20, height: dateText.preferredFrameSize().height))
        dateText.fontSize = 17
        dateText.contentsScale = UIScreen.main.scale
        
        dateBg.frame = CGRect(x: 0, y: bounds.height - dateText.preferredFrameSize().height, width: 26, height: dateText.preferredFrameSize().height)
        dateBg.masksToBounds = true
    }
}
