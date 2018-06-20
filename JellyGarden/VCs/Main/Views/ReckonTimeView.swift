//
//  ReckonTimeView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/8.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ReckonTimeView: UIView {
    typealias ReckonTimeViewComplection = (Bool) -> Void
    var complete:ReckonTimeViewComplection
    
    
    var maxTime:CGFloat = 0.0
    
    
    private var runtime:CGFloat = 0.0
    var timer:Timer?
    
    lazy var lable:UILabel = {
       let la = creatLable(frame: self.bounds, title: nil, font: kFont_system16, textColor: UIColor.white)
        la.backgroundColor = UIColor.clear
        la.textAlignment = NSTextAlignment.center
        return la
    }()
    lazy var imageV:UIImageView = {
        let iamgeWidth:CGFloat = 90
        let origiX = ( self.frame.width - iamgeWidth) / 2.0
        let origiY = ( self.frame.height - iamgeWidth) / 2.0
        let v = UIImageView.init(frame: CGRect.init(x:origiX, y: origiY, width: iamgeWidth, height: iamgeWidth))
        return v
    }()
    
    init(frame: CGRect ,time:CGFloat ,runComplection:@escaping (Bool) -> Void) {
        self.complete = runComplection
        super.init(frame: frame)
        self.maxTime = time
        self.runtime = maxTime
        self.addSubview(imageV)
        self.addSubview(lable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func starAnimatin() {
        self.imageV.image = imageName(name: "")
        let lineCurve = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        let animation = CABasicAnimation.init(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = 2 * Double.pi
        animation.duration = CFTimeInterval(0.5)
        animation.repeatDuration = CFTimeInterval(self.maxTime)
        animation.isRemovedOnCompletion = true
        animation.timingFunction = lineCurve
        animation.fillMode = kCAFillModeForwards
        animation.autoreverses = false
        imageV.layer.add(animation, forKey: "keyFrameAnimation")
        let timeTarget:ZZYTimerTarget = ZZYTimerTarget.init(target: self)
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: timeTarget, selector: #selector(timerRun), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    @objc func timerRun()
    {
        self.runtime = self.runtime - 0.1
        let str  = String.init(format: "%.1f", self.runtime)
        lable.text = str
        if self.runtime <= 0.0 {
            self.stopTimer()
        }
        
    }
    func stopTimer() {
        self.timer?.invalidate()
        self.lable.text = ""
        self.imageV.isHidden = true
        self.runtime = maxTime
        self.complete(true)
    }
    func createMyView() {
        let lable = UILabel.init(frame: self.frame)
        self.addSubview(imageV)
        lable.textAlignment = NSTextAlignment.center
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
