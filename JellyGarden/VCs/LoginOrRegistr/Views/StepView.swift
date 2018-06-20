//
//  stepView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/20.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class StepView: UIView {
    
    

    @IBOutlet weak var oneStep: UILabel!
    
    @IBOutlet weak var twoStep: UILabel!
    @IBOutlet weak var threeStep: UILabel!
    var tagFram:CGRect?
    
    override func draw(_ rect: CGRect) {
        self.frame = tagFram!
    }
    class func createStepView(step:Int) -> StepView?{
        let nibView = CustomCreateNib<StepView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        if step == 2 {
            view.threeStep.backgroundColor = APPCustomGrayColor
            view.threeStep.textColor  = UIColor.darkGray
        }
        if step == 1 {
            view.twoStep.backgroundColor = APPCustomGrayColor
            view.twoStep.textColor  = UIColor.darkGray
            view.threeStep.backgroundColor = APPCustomGrayColor
            view.threeStep.textColor  = UIColor.darkGray
        }
        view.oneStep.layer.cornerRadius = 10
        view.oneStep.clipsToBounds = true
        view.twoStep.layer.cornerRadius = 10
        view.twoStep.clipsToBounds = true
        view.threeStep.layer.cornerRadius = 10
        view.threeStep.clipsToBounds = true

        return view
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
