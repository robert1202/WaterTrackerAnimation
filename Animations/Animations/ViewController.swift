//
//  ViewController.swift
//  Animations
//
//  Created by fly on 7/26/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: UIViewController {
    private let waterView = WaterTrackerView(frame: UIScreen.mainScreen().bounds)

    private let timePickerView = WaterPickerView(frame: CGRectMake(0, 40, 375, 120))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(waterView)
        waterView.waterDepth = 0.1
        waterView.maxWaveCurve = 5.0
        waterView.minWaveCurve = 4.5
        
        view.addSubview(timePickerView)
        
        let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake((screenWidth - 140)/2.0, screenHeight - 44 - 40 , 140, 44)
        button.setTitle("Drink", forState: .Normal)
        let textColor = UIColor(red:0.58, green:0.93, blue:0.99, alpha:1.00)
        
        button.setTitleColor(textColor, forState: .Normal)
        button.layer.borderColor = textColor.CGColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(drinkButtonClick(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(button)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func drinkButtonClick(button: UIButton) {
        let now = NSDate.init()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.stringFromDate(now)
        timePickerView.drinkWater(time)

        waterView.waterDepth += 0.05
        waterView.bubblesRiseUp()
        
        dringAnimation(button)
        
    }
    
    func dringAnimation(button: UIButton) {
        button.enabled = false
        UIView.animateWithDuration(0.3, animations: { 
            button.transform = CGAffineTransformMakeScale(2.0, 2.0)
            button.alpha = 0
            }) { (flag) in
                button.transform = CGAffineTransformIdentity
                button.alpha = 1
                button.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

