//
//  HabitsTableViewCell.swift
//  HabitApp
//
//  Created by Eric Castillo on 7/13/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class HabitsTableViewCell: UITableViewCell {
    
    var done: Bool = false {
        didSet {
            showDefaultView()
        }
    }
    var checkmarkBackgroundLayer = CALayer()
    let highlight = CALayer()
    let reorderBackgroundView = HabitCellReorderBackgroundView()

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkmarkView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 4
        clipsToBounds = true
        layer.masksToBounds = false
        
        layer.shadowPath = CGPath(roundedRect: CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y + 5, width: contentView.frame.width, height: contentView.frame.height - 10), cornerWidth: 4, cornerHeight: 4, transform: nil)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
     
        reorderBackgroundView.layer.cornerRadius = 4
        reorderBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        reorderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(reorderBackgroundView)
        reorderBackgroundView.layer.zPosition = -1
        addConstraint(NSLayoutConstraint(item: reorderBackgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height-10))
        addConstraint(NSLayoutConstraint(item: reorderBackgroundView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: reorderBackgroundView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -3))
        addConstraint(NSLayoutConstraint(item: reorderBackgroundView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))

        highlight.frame = CGRect(x: 0, y: 0, width: 5, height: containerView.frame.height)
        highlight.zPosition = -1
        containerView.layer.addSublayer(highlight)
        
        containerView.layer.cornerRadius = 4
        checkmarkView.layer.borderWidth = 1
        checkmarkView.layer.cornerRadius = checkmarkView.frame.width/2
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            showEditingView()
        } else {
            showDefaultView()
        }
    }
    
    private func showEditingView() {
        editIconView.isHidden = false
        checkmarkView.isHidden = true
        highlight.frame.size.width = frame.width
        titleLabel.textColor = UIColor.white
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    private func showDefaultView() {
        editIconView.isHidden = true
        checkmarkView.isHidden = false
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        if done  {
            highlight.frame.size.width = frame.width
            titleLabel.textColor = UIColor.white
            checkmarkImageView.isHidden = false
        } else {
            highlight.frame.size.width = 5
            titleLabel.textColor = UIColor.black
            checkmarkImageView.isHidden = true
        }
    }
}
