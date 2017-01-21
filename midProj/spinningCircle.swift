//
//  SpinningCircleView.swift
//  p05
//
//  Created by Huayun Huang on 10/20/16.
//  Copyright © 2016 Huayun Huang. All rights reserved.
//

import UIKit

@IBDesignable
class SpinningCircleView: UIView {
    
    var openingDirection: CGFloat = 1.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var displayFlag = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // UI elements
    var circleColor: UIColor = UIColor(red: 0.2, green: 0.8, blue: 0.7, alpha: 1.0)
    var openingAngle: CGFloat = 0.35
    var radius: CGFloat = 140.0
    var lineWidth: CGFloat = 10.0

    
    override func draw(_ rect: CGRect) {
        let w = rect.width
        
        // draw an arc based on the opening of the curve
        let startAngle = openingDirection - openingAngle
        let endAngle = openingDirection + openingAngle
        
        let bigArc = UIBezierPath(arcCenter: CGPoint(x: w/2, y: w/2), radius: radius - lineWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        bigArc.lineWidth = lineWidth
        circleColor.setStroke()
        bigArc.stroke()
        
        let bigCircle = UIBezierPath(ovalIn: CGRect(x: w/2 - radius + lineWidth/2, y: w/2 - radius + lineWidth/2, width: radius * 2 - lineWidth,height: radius * 2 - lineWidth))
        circleColor.withAlphaComponent(0.3).setStroke()
        bigCircle.lineWidth = lineWidth
        bigCircle.stroke()
        
    }
    
}
