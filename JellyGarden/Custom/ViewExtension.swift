//
//  ViewExtension.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/11.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
extension UIView
{
    func addCorners(roundCorners:UIRectCorner,cornerSize:CGSize)
    {
        let path = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: roundCorners, cornerRadii: cornerSize)
        let corLayer = CAShapeLayer()
        corLayer.path = path.cgPath
        corLayer.frame = bounds
        layer.mask = corLayer
    }
    
    
    private struct RuntimeKey {
        static let imageKey = UnsafeRawPointer.init(bitPattern: "imageKey".hashValue)
        static let btnKey = UnsafeRawPointer.init(bitPattern: "lableKey".hashValue)
        static let backViewKey = UnsafeRawPointer.init(bitPattern: "bakKey".hashValue)
    }
    var blackBackView:UIView?//背景view
    {
        set{
            newValue?.frame = bounds
            objc_setAssociatedObject(self,RuntimeKey.backViewKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return (objc_getAssociatedObject(self, RuntimeKey.backViewKey!) as? UIView)
        }
    }
    
    
    var blankImageView:UIImageView?//占位图
    {
        set{
            objc_setAssociatedObject(self, RuntimeKey.imageKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, RuntimeKey.imageKey!) as? UIImageView)
        }
    }
    
    var descBtn:UIButton?//占位提示控件
    {
        set{
            objc_setAssociatedObject(self, RuntimeKey.btnKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self , RuntimeKey.btnKey!) as? UIButton)
        }
    }
    @objc private func clickErrorBtn()
    {
        
        zzy.router(name: "clickNoData", object: nil, info: self)
    }
    func showBlanckView()//显示
    {
        if self.blackBackView != nil{}
        else
        {
            self.blackBackView = {
                let view:UIView = UIView.init(frame: self.bounds)
                view.backgroundColor = UIColor.white
                return view
            }()
        }
        
        if self.blankImageView != nil{}
        else
        {
            self.blankImageView = {
                let image:UIImage? = imageName(name: "个人中心-蓝")
                let IMV:UIImageView = UIImageView.init(frame: CGRect.init(x: (bounds.width - (image?.size.width ?? 0.0)) / 2.0, y: (bounds.height - (image?.size.height ?? 30)) / 2.0 - 30, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0))
                IMV.image = image
                return IMV
            }()
        }
        if self.descBtn != nil{}
        else
        {
            self.descBtn =  {
                let title = "还没有数据哦~"
                let width:CGFloat = title.zzy.caculateWidth(font: kFont_system15)
                let btn:UIButton = UIButton.init(frame: CGRect.init(x: (bounds .width - width - 20) / 2.0, y: (self.blankImageView?.frame.maxY)! + 5, width: width + 20, height: 44))
                btn.setTitleColor(UIColor.gray, for: UIControlState.normal)
                btn.setTitle(title, for: UIControlState.normal)
                btn.addTarget(self, action: #selector(clickErrorBtn), for: UIControlEvents.touchUpInside)
                btn.backgroundColor = UIColor.clear
                return btn
            }()
        }
        self.blankImageView?.removeFromSuperview()
        self.descBtn?.removeFromSuperview()
        self.blackBackView?.removeFromSuperview()
        self.blackBackView?.frame = bounds
        let imageFrame:CGRect = CGRect.init(x: (bounds.width - (self.blankImageView!.image?.size.width ?? 0.0)) / 2.0, y: (bounds.height - (self.blankImageView!.image?.size.height ?? 0.0)) / 2.0, width: self.blankImageView!.image?.size.width ?? 0.0, height: self.blankImageView!.image?.size.height ?? 0.0)
        self.blankImageView?.frame = imageFrame
        let brnWidth:CGFloat = self.descBtn!.titleLabel?.text?.zzy.caculateWidth(font: kFont_system15) ?? 0.0
        let desBtnFrame = CGRect.init(x: (bounds .width - brnWidth - 20) / 2.0, y: (self.blankImageView!.frame.maxY) + 5, width: brnWidth + 20, height: 44)
        self.descBtn!.frame = desBtnFrame
        self.addSubview(self.blackBackView!)
        blackBackView!.addSubview(self.blankImageView!)
        blackBackView!.addSubview(self.descBtn!)
    }
    func hiddenBlackView()//隐藏
    {
        self.blackBackView?.removeFromSuperview()
    }
}

