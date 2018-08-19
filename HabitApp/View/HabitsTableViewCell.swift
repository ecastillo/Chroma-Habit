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
        
//        DispatchQueue.main.async {
//            self.titleLabel.text = self.habit?.name
//        }
        
//        DispatchQueue.main.async {
//            if self.done {
//                self.completedButton.setTitle("1", for: .normal)
//            } else {
//                self.completedButton.setTitle("2", for: .normal)
//            }
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func completedButtonTapped(_ sender: UIButton) {
        
//        var update = "o"
//        if self.done {
//            update = "o"
//        } else {
//            update = "x"
//        }
//        DispatchQueue.main.async {
//            self.completedButton.titleLabel?.text = update
//        }
        
        //done = !done
        
        delegate?.userTappedCellDoneButton(cell: self)
    }

}

protocol HabitCellDoneButtonTapped {
    func userTappedCellDoneButton(cell: HabitsTableViewCell)
}
