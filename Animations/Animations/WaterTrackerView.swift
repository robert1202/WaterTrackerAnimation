//
//  WaterTrackerView.swift
//  Animations
//
//  Created by fly on 7/26/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit
import PKHUD

class WaterTrackerView: UIView {
    var waveUp = false

    var waveCurve = 0.0
    var waveSpeed = 0.0
    
    private var _maxWaveCurve = 5.0
    internal var maxWaveCurve:Double{
        get {
            return _maxWaveCurve
        }
        set{
            waveCurve = newValue
        }
    }
    
    var waterOffset = 1.0
    var waterOffsetUp = false

    
    private var _minWaveCurve = 4.0
    internal var minWaveCurve:Double{
        get {
            return _minWaveCurve
        }
        set{
            _minWaveCurve = min(max(0.0, newValue), _maxWaveCurve + 0.5)
        }
    }
    
    let waterDepthLabel = UICountingLabel()

    /// 0 - 1.0
    private var _waterDepth = 0.0
    internal var waterDepth:Double{
        get {
            return _waterDepth
        }
        set{
            let oldCount = CGFloat(_waterDepth * 100)
            _waterDepth = min(max(0.0, newValue), 1.0)
            let newCount = CGFloat(_waterDepth * 100)
            waterDepthLabel.countFrom(oldCount, to: newCount, withDuration: 0.5)
         }
    }
    
    let shape1 = CAShapeLayer()
    let shape2 = CAShapeLayer()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        backgroundColor = UIColor(red:0.10, green:0.22, blue:0.29, alpha:1.00)
        
        let color1 = UIColor(red:0.00, green:0.73, blue:0.96, alpha:1.00)
        shape1.strokeColor = color1.CGColor
        shape1.fillColor = color1.CGColor
        shape1.frame = self.bounds
        shape1.lineWidth = 1.0
        
        self.layer.insertSublayer(shape1, atIndex: 0)
        
        let color2 = UIColor(red:0.00, green:0.48, blue:0.73, alpha:1.00)
        shape2.strokeColor = color2.CGColor
        shape2.fillColor = color2.CGColor
        shape2.frame = self.bounds
        shape2.lineWidth = 1.0
        
        self.layer.insertSublayer(shape2, atIndex: 0)
        
        let font = UIFont.systemFontOfSize(36)
        
        let width:CGFloat = 120
        let height = font.lineHeight
        let x = (CGRectGetWidth(frame) - width)/2.0
        let y = (CGRectGetHeight(frame) - height)/2.0
        
        waterDepthLabel.frame = CGRectMake(x, y, width, height)
        waterDepthLabel.font = UIFont.systemFontOfSize(36)
        waterDepthLabel.textColor = UIColor.whiteColor()
        waterDepthLabel.textAlignment = .Center
        waterDepthLabel.text = "0%"
        waterDepthLabel.method = .EaseIn;
        waterDepthLabel.format = "%d%%";
        addSubview(waterDepthLabel)
        

        let ti = 0.05
        

        NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(animateWave), userInfo: nil, repeats: true)
        
        NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(animateWave2), userInfo: nil, repeats: true)


//        let link = CADisplayLink(target: self, selector: #selector(animateWave))
//        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateWave() {

        


    }
    
    func animateWave2() {
        waveSpeed += 0.1

        
        if waterOffset <= 0.2 {
            waterOffsetUp = true
        }else if waterOffset >= M_PI {
            waterOffsetUp = false
        }
        waterOffset += (waterOffsetUp ? 0.1: -0.1)

        
        if waveCurve <= _minWaveCurve {
            waveUp = true
        }else if waveCurve >= _maxWaveCurve {
            waveUp = false
        }
        waveCurve += (waveUp ? 0.1: -0.1)

        
        shape2.path = getWavePath(waterOffset).CGPath
        
        shape1.path = getWavePath(0).CGPath
        
//        shape1.path = getWavePath(0).CGPath

        
//        waterOffset = 10
//
//        shape2.path = getWavePath(waterOffset).CGPath
    }
//    
//    func drawWaterRect() {
//        shape1.path = getWavePath(0).CGPath
//        shape2.path = getWavePath(waterOffset).CGPath
//    }
//    
    func getWavePath(offset: Double) -> UIBezierPath {
        let path = UIBezierPath()
        
        var y = Double(CGRectGetHeight(self.frame)) * (1.0 - _waterDepth)
        
        let waterDepthY = y
        
        path.moveToPoint(CGPointMake(0, CGFloat(waterDepthY)))

        var maxY = y
        var minY = y
        
        for x in 0..<Int(CGRectGetWidth(self.frame)){
            //y=Asin(ωx+φ)+k 正弦曲线
            //A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
            //(ωx+φ)——相位，反映变量y所处的状态。
            //φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
            //k——偏距，反映在坐标系上则为图像的上移或下移。
            //ω——角速度， 控制正弦周期(单位角度内震动的次数)。
            
            y = waveCurve * sin(Double(x) / 180 * M_PI + waveSpeed * 4.0 / M_PI + (offset > 0 ? waveSpeed : 0 )) * 4 + waterDepthY - offset
            if offset > 0 {
//                print("waveCurve = " + String(waveCurve) + " x = " + String(x) + " y = ",String(y))
//                print(offset)
                maxY = max(maxY, y)
                minY = min(minY, y)
            }
            path.addLineToPoint(CGPointMake(CGFloat(x), CGFloat(y)))
            
        }
        if offset > 0 {
//            print("minY = " + String(minY) + "maxY = " + String(maxY) + "\n\n")
            print(offset)
        }

        
        path.addLineToPoint(CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        path.addLineToPoint(CGPointMake(0, CGRectGetHeight(self.frame)))
        path.addLineToPoint(CGPointMake(0, CGFloat(waterDepthY)))
        path.closePath()
        
        return path
    }
    
    func bubblesRiseUp() {
        srand(UInt32(time(nil)))
        
        let offsetXList = NSMutableArray()
        for i in 1...6 {
            offsetXList.addObject(i * 20)
        }
        for _ in 1...3 {
            let index = Int(rand() % Int32(offsetXList.count))
            
            bubbleRiseUp(CGFloat(offsetXList[index] as! NSNumber))
        }
    }
    
    func bubbleRiseUp(offsetX: CGFloat) {
        
        let targetX = CGRectGetWidth(self.bounds)/2.0 - 100 + offsetX
        let targetY = CGFloat((CGRectGetHeight(self.frame)) * CGFloat(1.0 - _waterDepth))

        let bubble = CAShapeLayer()
        bubble.frame = CGRectMake(0, 0, 4, 4)
        bubble.fillColor = UIColor.whiteColor().CGColor
        bubble.strokeColor = UIColor.whiteColor().CGColor
        bubble.position = CGPointMake(targetX, CGRectGetHeight(self.bounds) - 40)
        
        let path = UIBezierPath(arcCenter: CGPointMake(5, 5), radius: 2, startAngle: 0, endAngle:CGFloat(M_PI * 2), clockwise: true)
        bubble.path = path.CGPath
        
        layer.addSublayer(bubble)
        
        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.toValue = NSValue.init(CGPoint: CGPointMake(targetX, targetY - 20))
        
        let animation2 = CABasicAnimation(keyPath: "opacity")
        animation2.toValue = 0.0
        
        let animation3 = CABasicAnimation(keyPath: "transform.scale")
        animation3.toValue = 2.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation1,animation2,animation3]
        animationGroup.duration = 0.4 * (1 + _waterDepth)
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.delegate = self
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        animationGroup.setValue(bubble, forKey: "firstAnimationLayerKey")
        bubble.addAnimation(animationGroup, forKey: nil)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let animationLayer = anim.valueForKey("firstAnimationLayerKey") as? CAShapeLayer
        let secondAniLayer = anim.valueForKey("secondAnimationLayerKey") as? CAShapeLayer

        if animationLayer != nil {
            let targetY = CGFloat((CGRectGetHeight(self.frame)) * CGFloat(1.0 - _waterDepth))
            let targetX = animationLayer!.position.x
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)

            animationLayer!.position = CGPointMake(targetX, targetY - 20)
            animationLayer!.transform = CATransform3DIdentity
            animationLayer!.opacity = 1
            
            CATransaction.commit()

            let startPath = self.getPoppitPath(true)
            animationLayer?.path = startPath.CGPath
            
            let endPath = self.getPoppitPath(false)

            let animation = CABasicAnimation(keyPath: "path")
            animation.toValue = endPath.CGPath
            animation.duration = 0.4
            animation.fillMode = kCAFillModeForwards
            animation.delegate = self
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
            animation.setValue(animationLayer!, forKey: "secondAnimationLayerKey")
            animationLayer!.addAnimation(animation, forKey: nil)

        }else if secondAniLayer != nil {
            secondAniLayer?.removeFromSuperlayer()
        }
    }
    
    func getPoppitPath(isStart: Bool) -> UIBezierPath {
        if isStart {
            let startPath = UIBezierPath()
            startPath.moveToPoint(CGPointMake(10 - 2, 10))
            startPath.addLineToPoint(CGPointMake(10 - 10, 10))
            
            startPath.moveToPoint(CGPointMake(10 + 2, 10))
            startPath.addLineToPoint(CGPointMake(10 + 10, 10))
            
            startPath.moveToPoint(CGPointMake(10, 10 - 2))
            startPath.addLineToPoint(CGPointMake(10, 10 - 10))
            return startPath
        }
        
        let endPath = UIBezierPath()
        endPath.moveToPoint(CGPointMake(10 - 9, 10))
        endPath.addLineToPoint(CGPointMake(10 - 10, 10))
        
        endPath.moveToPoint(CGPointMake(10 + 9, 10))
        endPath.addLineToPoint(CGPointMake(10 + 10, 10))
        
        endPath.moveToPoint(CGPointMake(10, 10 - 9))
        endPath.addLineToPoint(CGPointMake(10, 10 - 10))
        return endPath
    }
    
}
