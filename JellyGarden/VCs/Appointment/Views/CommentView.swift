//
//  CommentView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/21.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum CLickCommentType {
    case cancel;
    case publish;
}
typealias ClickTextFiledChange = (CLickCommentType,String?) ->Void
class CommentView: UIView {
    var clickType:ClickTextFiledChange?
    

    func clickChange(type:@escaping ClickTextFiledChange) {
        self.clickType = type
    }
    class func createCommentView() -> CommentView? {
        let nibView = CustomCreateNib<CommentView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        return view
    }
    @IBOutlet weak var commentTextFiled: UITextField!
    @IBAction func clickPublishBtn(_ sender: UIButton) {
        self.clickType?(.publish,self.commentTextFiled.text)
    }
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        self.clickType?(.cancel,self.commentTextFiled.text)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
