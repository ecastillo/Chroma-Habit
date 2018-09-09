//
//  HabitCellReorderBackgroundView.swift
//  HabitApp
//
//  Created by Eric Castillo on 9/3/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//
//  Technique to keep the background color taken from https://medium.com/@vhart/tableview-cell-reordering-keep-the-color-4c03623d2399

import UIKit

class HabitCellReorderBackgroundView: UIView {

    var color: UIColor = .clear {
        didSet {
            backgroundColor = color
        }
    }
    
    override var backgroundColor: UIColor? {
        set {
            guard newValue == color else { return }
            super.backgroundColor = newValue
        }
        
        get {
            return super.backgroundColor
        }
    }

}
