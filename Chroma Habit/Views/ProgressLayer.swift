//
//  ProgressLayer.swift
//  Chroma Habit
//
//  Created by Eric Castillo on 10/20/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit

class ProgressLayer: CAShapeLayer {
    enum ProgressLayerOrientation {
        case vertical
        case horizontal
    }
    var orientation:ProgressLayerOrientation = .vertical
    var sliceColors = [UIColor]() {
        didSet {
            sublayers?.removeAll()
            slices.removeAll()
            
            for sliceColor in sliceColors {
                let slice = CAShapeLayer()
                slice.backgroundColor = sliceColor.cgColor
                slices.append(slice)
                addSublayer(slice)
            }
        }
    }
    var slices = [CAShapeLayer]()
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        for (i, slice) in slices.enumerated() {
            slice.frame = bounds
            switch orientation {
            case .vertical:
                let sliceHeight = bounds.height/CGFloat(sliceColors.count)
                slice.frame.size.height = sliceHeight*CGFloat(i+1)
            case .horizontal:
                let sliceWidth = bounds.width/CGFloat(sliceColors.count)
                slice.frame.size.width = sliceWidth*CGFloat(i+1)
            }
            slice.zPosition = CGFloat(integerLiteral: -i)
        }
    }
}
