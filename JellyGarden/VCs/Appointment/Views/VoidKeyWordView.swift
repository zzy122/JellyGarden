//
//  VoidKeyWordView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class VoidKeyWordView: UIScrollView {
  
    override func layoutSublayers(of layer: CALayer) {//xib使用scrollview 然后还用到了IQKeyboardManager 重写scrolleview的layoutSublayers方法,不然改变frame没效果
        
    }
  
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
