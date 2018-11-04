//
//  WidgetTableViewCell.swift
//  Chroma Habit Widget
//
//  Created by Eric Castillo on 10/13/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var highlight: UIView!
    
    @IBOutlet var highlightNarrowWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
