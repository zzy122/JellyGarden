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
    let backView:UIView = {
       let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        
        return view
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
    
    
}
