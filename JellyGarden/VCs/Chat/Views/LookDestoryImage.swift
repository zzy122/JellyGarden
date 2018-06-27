
//
//  LookDestoryImage.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class LookDestoryImage: UIView {
    let imageView:LookImageBodyView = {
        let view1 = LookImageBodyView.createLookImageView()
        view1?.tagFrame = CGRect.init(x: 0, y: 100, width: ScreenWidth, height: ScreenHeight - 200)
        view1?.starLookEffect(type: LookImageType.clearness)
        return view1!
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
