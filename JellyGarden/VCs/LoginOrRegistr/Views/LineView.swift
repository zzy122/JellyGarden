//
//  LineView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/20.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class LineView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        // 设置线条的样式
        context?.setLineCap(CGLineCap.round)
        
        // 绘制线的宽度
        context?.setLineWidth(3.0)
        // 线的颜色
        context?.setStrokeColor(UIColor.gray.cgColor)
        // 开始绘制
        context?.beginPath()
        // 设置虚线绘制起点
        context?.move(to: CGPoint.init(x: 10, y: 10))
        // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
        // 虚线的起始点
        context?.setLineDash(phase: 2, lengths: [5.0,5.0])
        // 绘制虚线的终点
        context?.addLine(to: CGPoint.init(x: self.frame.width, y: 10))
        // 绘制
        context?.strokePath()
        context?.closePath()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
