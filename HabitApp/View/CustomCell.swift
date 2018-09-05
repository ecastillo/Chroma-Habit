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
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var selectedView: UIView!
    //@IBOutlet weak var progressView: MGSegmentedProgressBar?
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowView: UIView!
   // @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var progressStackViewContainer: UIView!
    
    var border = CALayer()
    //var outsideBorder = CALayer()
    
    //var progressView: MGSegmentedProgressBar?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.addSublayer(border)
        
        //outsideBorder.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
//        outsideBorder.backgroundColor = UIColor.white.cgColor
//        outsideBorder.zPosition = -1
//        outsideBorder.shadowColor = UIColor.black.cgColor
//        outsideBorder.shadowRadius = 20
//        outsideBorder.shadowOffset = CGSize(width: 3, height: 3)
//        outsideBorder.shadowPath = CGPath(rect: outsideBorder.frame, transform: nil)
//        outsideBorder.masksToBounds = false
//        clipsToBounds = false
//        layer.addSublayer(outsideBorder)
    }
    
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//       // outsideBorder.frame = frame
//    }
}
