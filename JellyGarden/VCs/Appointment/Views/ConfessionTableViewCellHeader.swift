//
//  ConfessionTableViewCellHeader.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickLikeChangeBtn = "ClickLikeChangeBtn"
let ClickDeleteBtn = "ClickDeleteBtn"

let ClickCommentBtn = "ClickCommentBtn"
class ConfessionTableViewCellHeader: UIView {


    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var publishLab: UILabel!
    @IBOutlet weak var sexImage: UIImageView!
    @IBOutlet weak var authTrueLab: UILabel!
    @IBOutlet weak var nikeName: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    class  func createConfessionTableViewCellHeader() -> ConfessionTableViewCellHeader? {
        let nibView = CustomCreateNib<ConfessionTableViewCellHeader>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.headerImage.clipsToBounds = true
        view.headerImage.layer.cornerRadius = 18
        view.authTrueLab.layer.cornerRadius = 5.0
        view.authTrueLab.clipsToBounds = true
        return view
    }
    @IBAction func clickLikeBtn(_ sender: UIButton) {
        
        zzy.router(name: ClickLikeChangeBtn, object: nil, info: self.tag)
        
        
    }
    
    @IBAction func clickCommentBtn(_ sender: UIButton) {
        zzy.router(name: ClickCommentBtn, object: nil, info: self.tag)
    }
    
    @IBAction func clickDeletBtn(_ sender: UIButton) {
        zzy.router(name: ClickDeleteBtn, object: nil, info: self.tag)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
