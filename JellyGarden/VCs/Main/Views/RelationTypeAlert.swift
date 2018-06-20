//
//  RelationTypeAlert.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum ClickRelationType {
    case close;
    case sure;
    case report;
}
let ClickRelationTypeStr = "ClickRelationTypeStr"
typealias FinishRelationType = (ClickRelationType) ->Void

class RelationTypeAlert: UIView {
    
    @IBOutlet weak var shareContactBtn: UIButton!
    var complete:FinishRelationType?
    
    @IBAction func clickClose(_ sender: UIButton) {
        self.complete?(.close)
    }
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var introduceText: UILabel!
    @IBOutlet weak var contactText: UILabel!
    @IBOutlet weak var introduceLab: UILabel!
    @IBOutlet weak var contactTypeLab: UILabel!
    @IBAction func clickReportBtn(_ sender: UIButton) {
        
        self.complete?(.report)
        
    }
    @IBAction func clickSendMyContactBtn(_ sender: UIButton) {
        self.complete?(.sure)
        
    }
    @IBAction func clickCopyBtn(_ sender: UIButton) {
        UIPasteboard.general.string = self.contactText.text
        alertHud(title: "已复制到粘贴板")
    }
    var tagFrame:CGRect?
    override func draw(_ rect: CGRect) {
        self.frame = tagFrame!
    }
    class func createRelationTypeAlert(title:String,contactTypeStr:String?,contactText:String,introduceStr:String?,frame:CGRect,complect:@escaping FinishRelationType) -> RelationTypeAlert? {
        let nibView =  CustomCreateNib<RelationTypeAlert>().createXibView()
        guard let view = nibView  else {
            return nil
        }
        view.complete = complect
        view.titleLable.text = title
        view.contactTypeLab.text = contactTypeStr
        view.contactText.text = contactText
        view.introduceText.text = introduceStr
        view.tagFrame = frame
        
        return view
    }
    
    
}
