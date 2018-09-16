//
//  ColorButton.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/18/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    
    let shapeLayer = CAShapeLayer()
    var shapeRect = CGRect()
    var color = UIColor.gray
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shapeLayer.isHidden = true
        layer.addSublayer(shapeLayer)
        layer.cornerRadius = frame.width/2
    }
    
    override func layoutSubviews() {
        backgroundColor = color
        
        shapeRect = CGRect(x: 0, y: 0, width: frame.width+5, height: frame.height+5)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [5,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: shapeRect.width/2).cgPath
    }
    
    override var isSelected: Bool {
        didSet {
            shapeLayer.isHidden = !isSelected
        }
    }
}
