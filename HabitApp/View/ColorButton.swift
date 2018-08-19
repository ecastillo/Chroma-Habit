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
    var color: UIColor?
    
    required init(frame: CGRect, mycolor: UIColor) {
        color = mycolor
        super.init(frame: frame)
        
        backgroundColor = color
        layer.cornerRadius = frame.width/2
        
        let shapeRect = CGRect(x: 0, y: 0, width: frame.width+4, height: frame.height+4)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color?.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [5,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: shapeRect.width/2).cgPath
        shapeLayer.isHidden = true
        
        layer.addSublayer(shapeLayer)
    }
    
    override var isSelected: Bool {
        didSet {
            shapeLayer.isHidden = !isSelected
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
