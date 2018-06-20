//
//  commentGetHeight.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/13.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CommentGetHeight: NSObject {
    class func getHeightCell(title:String?,commentStr:String?) -> CGFloat
    {
        let titleWidth:CGFloat = title?.zzy.caculateWidth(font: kFont_system15) ?? 0.0
        let height = commentStr?.zzy.caculateHeight(font: kFont_system15, width: ScreenWidth - 25 - titleWidth, lineSpace: 8) ?? titleWidth
        
        return height
    }
}

