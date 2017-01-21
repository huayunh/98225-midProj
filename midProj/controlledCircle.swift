//
//  ControlledCircleView.swift
//  p05
//
//  Created by Huayun Huang on 10/20/16.
//  Copyright © 2016 Huayun Huang. All rights reserved.
//

import UIKit

@IBDesignable class ControlledCircleView: UIView {
    
    var radius: CGFloat = 20.0
    
    var origin: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var circleColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
    var displayFlag: Int = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let w = rect.width
        
        let currRect = CGRect(x: origin.x - radius + w/2,
                              y: origin.y - radius + w/2,
                              width: radius * 2,
                              height: radius * 2)
        
        let circle = UIBezierPath(ovalIn: currRect)
        circleColor.setFill()
        circle.fill()
    }
    
}
