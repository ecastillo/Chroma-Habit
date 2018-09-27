//
//  HabitsTableView.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/31/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class HabitsTableView: UITableView {

    // Prevent the UITableView from detecting taps in the top inset
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (point.y<0) {
            return nil;
        }
        return hitView;
    }
    
    // Prevent UITableView from addind a shadow to a cell when reordering
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if "\(type(of: subview))" == "UIShadowView" {
            subview.removeFromSuperview()
        }
    }

}
