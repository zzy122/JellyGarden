//
//  CommentStarView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/28.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickStarFinish =  "ClickStarFinish"
let commentAry:[String] = ["礼貌","好玩","大方","干净","不拖拉","口嗨"]
class CommentStarView: UIView {
    typealias close = (Bool) -> Void
    var clickClose:close?
    
    //口嗨
    @IBOutlet weak var mouthLable: UILabel!
    @IBOutlet weak var mouthView: GFStarView!
    //不拖拉
    @IBOutlet weak var agileLable: UILabel!
    @IBOutlet weak var agileView: GFStarView!
    //干净
    @IBOutlet weak var cleanLable: UILabel!
    @IBOutlet weak var cleanView: GFStarView!
    //大方
    @IBOutlet weak var tasteLable: UILabel!
    @IBOutlet weak var tasteView: GFStarView!
    //好玩
    @IBOutlet weak var playLab: UILabel!
    @IBOutlet weak var playView: GFStarView!
    //礼貌
    @IBOutlet weak var politeLab: UILabel!
    @IBOutlet weak var politeView: GFStarView!
    @IBOutlet weak var nikeNameLable: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
//    var tagFrame:CGRect?
//    override func draw(_ rect: CGRect) {
//        self.frame = tagFrame!
//    }
//    override func layoutSubviews() {
//        self.frame = tagFrame!
//    }
    class func createCommentStarView() ->CommentStarView?
    {
        let nibView = CustomCreateNib<CommentStarView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.headerImage.layer.cornerRadius = 40
        view.headerImage.clipsToBounds = true
        
        view.politeView.isOnlyShow = false
        view.politeView.selectedStarImage = imageName(name: "满星")!
        view.politeView.normalStarImage = imageName(name: "星")!
        view.politeView.totalStar = 5
        view.politeView.clickBack = {[weak view] count in
            view?.politeLab.text = String.init(format: "%d", count)
        }
        
        view.playView.isOnlyShow = false
        view.playView.selectedStarImage = imageName(name: "满星")!
        view.playView.normalStarImage = imageName(name: "星")!
        view.playView.totalStar = 5
        view.playView.clickBack = {[weak view] count in
            view?.playLab.text = String.init(format: "%d", count)
        }
        
        view.tasteView.isOnlyShow = false
        view.tasteView.selectedStarImage = imageName(name: "满星")!
        view.tasteView.normalStarImage = imageName(name: "星")!
        view.tasteView.totalStar = 5
        view.tasteView.clickBack = {[weak view] count in
            view?.tasteLable.text = String.init(format: "%d", count)
        }
        
        view.cleanView.isOnlyShow = false
        view.cleanView.selectedStarImage = imageName(name: "满星")!
        view.cleanView.normalStarImage = imageName(name: "星")!
        view.cleanView.totalStar = 5
        view.cleanView.clickBack = {[weak view] count in
            view?.cleanLable.text = String.init(format: "%d", count)
        }
        
        view.agileView.isOnlyShow = false
        view.agileView.selectedStarImage = imageName(name: "满星")!
        view.agileView.normalStarImage = imageName(name: "星")!
        view.agileView.totalStar = 5
        view.agileView.clickBack = {[weak view] count in
            view?.agileLable.text = String.init(format: "%d", count)
        }
        
        view.mouthView.isOnlyShow = false
        view.mouthView.selectedStarImage = imageName(name: "满星")!
        view.mouthView.normalStarImage = imageName(name: "星")!
        view.mouthView.totalStar = 5
        view.mouthView.clickBack = {[weak view] count in
            view?.mouthLable.text = String.init(format: "%d", count)
        }
        return view
    }
    @IBAction func clickCommentBtn(_ sender: UIButton) {
        clickClose?(true)
    }
    @IBAction func clickClose(_ sender: UIButton) {
        zzy.router(name: ClickStarFinish, object: nil, info: nil)
        clickClose?(false)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
