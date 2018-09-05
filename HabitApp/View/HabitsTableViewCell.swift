//
//  HabitsTableViewCell.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/13/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class HabitsTableViewCell: UITableViewCell {
    
    var habit: Habit?
    var date: Date?
    var done = false
    var delegate: HabitCellDoneButtonTapped?
    var delegate2: HabitCellDetailButtonTapped?
    let highlight = CALayer()
    let bottomBorder = CALayer()
    let xyz = HabitCellReorderBackgroundView()
    var ddd = NSLayoutConstraint()
    var checkmarkBackgroundLayer = CALayer()

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var checkmarkView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print(frame)
        
        layer.cornerRadius = 4
        clipsToBounds = true
        
        //titleView.layer.cornerRadius = 4
        //titleView.clipsToBounds = true
        
        layer.masksToBounds = false
        
        layer.shadowPath = CGPath(roundedRect: CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y + 5, width: contentView.frame.width, height: contentView.frame.height - 10), cornerWidth: 4, cornerHeight: 4, transform: nil)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
     
        xyz.layer.cornerRadius = 4
        xyz.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        xyz.translatesAutoresizingMaskIntoConstraints = false
        addSubview(xyz)
        xyz.layer.zPosition = -1
        addConstraint(NSLayoutConstraint(item: xyz, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height-10))
        addConstraint(NSLayoutConstraint(item: xyz, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        //addConstraint(NSLayoutConstraint(item: xyz, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        ddd = NSLayoutConstraint(item: xyz, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -3)
        addConstraint(ddd)
        addConstraint(NSLayoutConstraint(item: xyz, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        
        
//        layer.bounds = frame
//        layer.masksToBounds = true
        
        //bottomBorder.frame = CGRect(x: 0, y: titleView.frame.height-1, width: frame.width, height: 1)
        //bottomBorder.zPosition = -2
        //titleView.layer.addSublayer(bottomBorder)
        
        //highlight.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        //highlight.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //highlight.frame = CGRect(x: 0, y: 0, width: 10, height: self.frame.height)
        highlight.frame = CGRect(x: 0, y: 0, width: 5, height: containerView.frame.height)
       // highlight.position = CGPoint(x: 0, y: 0)
        highlight.zPosition = -1
        containerView.layer.addSublayer(highlight)
        
        containerView.layer.cornerRadius = 4
        
//        checkmarkBackgroundLayer.frame = CGRect(x: -4, y: -4, width: checkmarkView.frame.size.width + 8, height: checkmarkView.frame.size.height + 8)
//        checkmarkBackgroundLayer.backgroundColor = UIColor.green.cgColor
//        checkmarkBackgroundLayer.cornerRadius = checkmarkBackgroundLayer.frame.width/2
//        checkmarkBackgroundLayer.borderWidth = 1
//        checkmarkBackgroundLayer.zPosition = -2
//        checkmarkView.layer.addSublayer(checkmarkBackgroundLayer)
        
        checkmarkView.layer.borderWidth = 1
        checkmarkView.layer.cornerRadius = checkmarkView.frame.width/2
        
        //editIconView.tintColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //layer.bounds = frame
        //layer.masksToBounds = false
        //contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
        
        //xyz.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y - 10, width: contentView.frame.width, height: contentView.frame.height-20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            highlight.frame.size.width = frame.width
            titleLabel.textColor = UIColor.white
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            editIconView.isHidden = false
            checkmarkView.isHidden = true
        } else {
            editIconView.isHidden = true
            checkmarkView.isHidden = false
            UIView.animate(withDuration: 0.4,
                           animations: {
                            self.containerView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                            //self.ddd.constant = 0
            })
            if done {
                highlight.frame.size.width = frame.width
                titleLabel.textColor = UIColor.white
            } else {
                highlight.frame.size.width = 5
                titleLabel.textColor = UIColor.black
            }
        }
    }

    @IBAction func completedButtonTapped(_ sender: UIButton) {
        delegate?.userTappedCellDoneButton(cell: self)
    }

    @IBAction func detailButtonTapped(_ sender: UIButton) {
        delegate2?.userTappedCellDetailButton(cell: self)
    }
}

protocol HabitCellDoneButtonTapped {
    func userTappedCellDoneButton(cell: HabitsTableViewCell)
}

protocol HabitCellDetailButtonTapped {
    func userTappedCellDetailButton(cell: HabitsTableViewCell)
}
