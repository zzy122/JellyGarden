//
//  AlertAction.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AlertAction: NSObject {
    static let share = AlertAction()
    private override init() {
        
    }
    typealias clickCommentStarView = (_ polite:Int,_ play:Int,_ taste:Int,_ clean:Int,_ agile:Int,_ mouth:Int) -> Void
    let commentHeight:CGFloat = 70.0
    var isGetBordHeight:CGFloat = 0.0
    var commentViewHeight:CGFloat = 350 * SCALE
    lazy var commentView:CommentStarView = {
        let view:CommentStarView = CommentStarView.createCommentStarView()!
        view.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: commentViewHeight)
        
        
        return view
    }()
    
    let backView:UIView = {
       let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        
        return view
    }()
    
    lazy var comment:CommentView = {
        let view = CommentView.createCommentView()

        return view!
    }()
    
    var contactAlert:RelationTypeAlert?
    
    var bottomPicker:BottomAlert?
    
    
    var alertView:APPCustomAlertView?
    
    func showAlertView(type:UIKeyboardType?,title: String?, placeHodel: String, detailTitle: String?, detailImage: UIImage?, click:@escaping (Bool,String?) -> Void) {
        UIApplication.shared.keyWindow?.addSubview(self.backView)
        alertView = APPCustomAlertView.createAlertView(title: title, placeHodel: placeHodel, detailTitle: detailTitle, detailImage: detailImage, frame: CGRect.init(x: 20, y: (ScreenHeight - 240) / 2.0, width: ScreenWidth - 40, height: 240)) { (sure,Str) in
            click(sure,Str)
            self.hiddenTheView(view: self.alertView)
        }
        alertView?.inputTextView.keyboardType = type ?? UIKeyboardType.default
        self.showTheView(View: alertView)
        UIApplication.shared.keyWindow?.addSubview(alertView!) 
    }
    func showBackView()  {
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backView.alpha = 0.3
        UIView.commitAnimations()
    }
    func showTheView(View:UIView?) {
        
        self.showBackView()
        let animation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.30;
        animation.isRemovedOnCompletion = true;
        animation.fillMode = kCAFillModeForwards;
        let valus = NSMutableArray()
        valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = valus as? [Any]
        View?.layer.add(animation, forKey: nil)
    }
    func hiddenTheView(view:UIView?) {
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        self.backView.alpha = 0.0
        UIView.commitAnimations()
        view?.isHidden = false
        view?.removeFromSuperview()
        
    }
    //maxCount 做多可以选择天剑的个数  dataary:数据源 curruntData:当前的数据
    func showbottomPicker(title:String?, maxCount:Int, dataAry:[PikerModel]?,currentData:[String]?, backData:@escaping ([String]) -> Void) {
        UIApplication.shared.keyWindow?.addSubview(self.backView)
        bottomPicker = BottomAlert.init(frame: CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 300), dataAry: dataAry, currentData: currentData, backData: { (resultData) in
            guard let data = resultData else {
                self.hiddenBottomView()
                return
            }
            self.hiddenBottomView()
            backData(data)
            
        })
        bottomPicker?.maxCount = maxCount
        bottomPicker?.titleLable?.text = title
        
        self.showBottom()
        UIApplication.shared.keyWindow?.addSubview(bottomPicker!)
        
    }
    func showBottom() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomPicker?.frame = CGRect.init(x: 0, y: ScreenHeight - 300, width: ScreenWidth, height: 300)
            self.backView.alpha = 0.3
        }) { (complete) in
            
        }
    }
    func hiddenBottomView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomPicker?.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 300)
            self.backView.alpha = 0.0
        }) { (complete) in
            if complete {
                self.bottomPicker?.removeFromSuperview()
                self.backView.removeFromSuperview()
            }
        }
        
    }
    
    //
    func showContactAlert(title:String,contactTypeStr:String?,contactText:String,introduceStr:String?,complection:@escaping FinishRelationType) {
        UIApplication.shared.keyWindow?.addSubview(self.backView)
        contactAlert = RelationTypeAlert.createRelationTypeAlert(title: title, contactTypeStr: contactTypeStr, contactText: contactText, introduceStr: introduceStr, frame: CGRect.init(x: 20, y: (ScreenHeight - 240) / 2.0, width: ScreenWidth - 40, height: 300), complect: { (type) in
            complection(type)
            self.hiddenTheView(view: self.contactAlert)
        })
        contactAlert?.layer.cornerRadius = 8.0
        contactAlert?.clipsToBounds = true
        self.showTheView(View: contactAlert)
        UIApplication.shared.keyWindow?.addSubview(contactAlert!)
    }
    func showCommentView(clickType:@escaping ClickTextFiledChange)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        comment.clickChange {[weak self] (type, str) in
            self?.comment.commentTextFiled.resignFirstResponder()
            DebugLog(message: "\(String(describing: str))")
            clickType(type,str)
        }
       
        comment.commentTextFiled.text = ""
        UIApplication.shared.keyWindow?.addSubview(self.backView)
        self.showBackView()
        comment.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: commentHeight)
        comment.setNeedsLayout()
        UIApplication.shared.keyWindow?.addSubview(comment)
        comment.commentTextFiled.becomeFirstResponder()
        
    }
    func showCommentStarView(imageUrl:String?,nikeStr:String?, complectiom:@escaping clickCommentStarView) {
         UIApplication.shared.keyWindow?.addSubview(self.backView)
        
        self.showBottom()
        self.commentView.isHidden = false
        self.commentView.politeView.reloadData()
        self.commentView.playView.reloadData()
        self.commentView.tasteView.reloadData()
        self.commentView.cleanView.reloadData()
        self.commentView.agileView.reloadData()
        self.commentView.mouthView.reloadData()
        self.commentView.headerImage.sd_DownLoadImage(url: imageUrl ?? "")
        self.commentView.nikeNameLable.text = nikeStr
        self.commentView.clickClose = {[weak self] sure in
            UIView.animate(withDuration: 0.3, animations: {
                self?.commentView.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: self?.commentViewHeight ?? 0)
            }, completion: { (complection) in
                if complection {
                    if (sure)
                    {
                    complectiom(self?.commentView.politeView.star ?? 0,self?.commentView.playView.star ?? 0,self?.commentView.tasteView.star ?? 0,self?.commentView.cleanView.star ?? 0,self?.commentView.agileView.star ?? 0,self?.commentView.mouthView.star ?? 0)
                    }
                    
                    
                    self?.commentView.removeFromSuperview()
                    self?.backView.removeFromSuperview()
                }
                
            })
        }
        UIApplication.shared.keyWindow?.addSubview(self.commentView)
        comment.setNeedsLayout()
        UIView.animate(withDuration: 0.5, animations: {
            self.commentView.frame = CGRect.init(x: 0, y: ScreenHeight - self.commentViewHeight, width: ScreenWidth, height: self.commentViewHeight)
        }) { (complection) in
            
        }
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            self.comment.frame = CGRect.init(x: 0, y:ScreenHeight - deltaY - self.commentHeight, width: ScreenWidth, height: self.commentHeight)
            self.comment.setNeedsLayout()
            DebugLog(message: "键盘高度:\(deltaY)")
        }
        if duration > 0 {
            if isGetBordHeight != deltaY{
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
                
                UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            }
            isGetBordHeight = deltaY
        }else{
            animations()
        }
    }
    @objc func keyboardWillHidden(note: NSNotification) {
        let userInfo  = note.userInfo!
        self.backView.alpha = 0.0
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            self.comment.frame = CGRect.init(x: 0, y:ScreenHeight, width: ScreenWidth, height: self.commentHeight)
            DebugLog(message: "键盘高度:\(duration)")
        }
        if duration > 0 {
            if isGetBordHeight != 0.0 {
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
                
                UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: {(complection) in
                    if complection
                    {
                        DebugLog(message: "移除")
                        self.backView.removeFromSuperview()
                        self.comment.removeFromSuperview()
                        NotificationCenter.default.removeObserver(self)
                    }
                    
                })
            }
            isGetBordHeight = 0.0
        }else{
        }
        
    }
   
    
    
    
    
}
