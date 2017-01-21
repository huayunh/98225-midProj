//
//  ViewController.swift
//  midProj
//
//  Created by Huayun Huang on 10/20/16.
//  Copyright © 2016 Huayun Huang. All rights reserved.
//

import UIKit
import CoreMotion
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var spinningCircle: SpinningCircleView!
    @IBOutlet weak var controlledCircle: ControlledCircleView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var motionManager: CMMotionManager!
    var circleSpeed: CGFloat!
    var circleDirection: CGFloat!
    var paused: Bool!
    var restartFlag: Bool!
    var score: Int!
    
    func updateAccelerometerData(theData: CMAccelerometerData?, theError: Error?){
        if paused! {
            return
        }
        if let acceData = theData {
          //  controlledCircle.angle = atan(CGFloat(acceData.acceleration.y)/CGFloat(acceData.acceleration.x))
          //  controlledCircle.distance += circleSpeed
            spinningCircle.openingDirection = -atan(CGFloat(acceData.acceleration.y)/CGFloat(acceData.acceleration.x))
            if acceData.acceleration.x < 0 {
                spinningCircle.openingDirection += CGFloat(M_PI)
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func tapInsidePauseButton(_ sender: AnyObject) {
        toggleButton()
    }
    
    func toggleButton(){
        if paused!{
            pauseButton.setTitle("", for: .normal)
        }
        else {
            pauseButton.setTitle("START", for: .normal)
        }
        if restartFlag!{
            scoreLabel.text = "0"
            restartFlag = false
            score = 0
        }
        paused = !paused
    }
    
    func updateAnimation(){
        spinningCircle.displayFlag += 1
        controlledCircle.displayFlag += 1
    }
    
    func newDirection(){
//        circleDirection = -circleDirection + CGFloat(Double(arc4random_uniform(100)) / 100.0)
        circleDirection = circleDirection + CGFloat(arc4random_uniform(2)) + 2
    }
    
    func restartGame() {
        toggleButton()
        circleDirection = CGFloat(M_PI_2)
        controlledCircle.origin = CGPoint(x:0.0, y:0.0)
        restartFlag = true
        circleSpeed = 1.8
    }
    
    func checkIfCircleFallsOnArc() -> Bool{
        var newCircleD = atan(controlledCircle.origin.y / controlledCircle.origin.x)
        if controlledCircle.origin.x < 0{
            newCircleD = newCircleD + CGFloat(M_PI)
        }
        let e = newCircleD.truncatingRemainder(dividingBy: CGFloat(M_PI * 2))
        if (abs(e - spinningCircle.openingDirection) <= spinningCircle.openingAngle + 0.1 ||
            abs(e - (spinningCircle.openingDirection + CGFloat(M_PI * 2))) <= spinningCircle.openingAngle + 0.1 ||
            abs(e - (spinningCircle.openingDirection - CGFloat(M_PI * 2))) <= spinningCircle.openingAngle + 0.1
            ) {
            return true
        }
        else {
            return false
        }
    }
    
    func update() {
        if paused! {
            return
        }
        let o = controlledCircle.origin
        let d = sqrt(o.x * o.x + o.y * o.y)
        if d < spinningCircle.radius - controlledCircle.radius - spinningCircle.lineWidth{
            // still in the middle, add speed to the circle
            spinningCircle.circleColor = UIColor(red: 0.2, green: 0.8, blue: 0.7, alpha: 1.0)
        }
        else{
            if checkIfCircleFallsOnArc() {
                spinningCircle.circleColor = controlledCircle.circleColor
                controlledCircle.origin.x -= circleSpeed * cos(circleDirection) * 2
                controlledCircle.origin.y -= circleSpeed * sin(circleDirection) * 2
                newDirection()
                score = score + 1
                scoreLabel.text = String(score!)
                if 10 <= score && score <= 20{
                    circleSpeed = 0.06 + circleSpeed
                }else if 40 <= score && score <= 50{
                    circleSpeed = 0.04 + circleSpeed
                }
            }
            else {
                restartGame()
                updateAnimation()
                return
            }
        }
        controlledCircle.origin.x += circleSpeed * cos(circleDirection)
        controlledCircle.origin.y += circleSpeed * sin(circleDirection)
        updateAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paused = true
        restartFlag = false
        score = 0
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue(),
                                                       withHandler: updateAccelerometerData)
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        circleSpeed = 1.8
        circleDirection = CGFloat(M_PI_4)
        
    }
    


}

