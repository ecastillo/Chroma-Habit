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

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func completedButtonTapped(_ sender: UIButton) {
        delegate?.userTappedCellDoneButton(cell: self)
    }

}

protocol HabitCellDoneButtonTapped {
    func userTappedCellDoneButton(cell: HabitsTableViewCell)
}
