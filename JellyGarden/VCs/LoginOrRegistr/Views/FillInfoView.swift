//
//  FillInfoView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
let FillInfoViewClick = "FillInfoViewClick"
let ClickFillInfoViewHeader = "ClickFillInfoViewHeader"

class FillInfoView: UIView,UITableViewDataSource,UITableViewDelegate {
    var oppintRange:[String]? = [""]//保存范围
    var age:String?//年龄
    var identity:String?//身份
    var bodyHeight:String?//身高
    var bodyWeight:String?//体重
    var bodyChest:String?//胸围
    var imageUrlStr:String?//头像地址
    
    let ageList:[PikerModel] = {
        var dicAry:[[String:Any]] = []
        for i in 15 ..< 46 {
            let dic:[String:Any] = ["citysName":i]
            dicAry.append(dic)
        }
        return JSONDeserializer<PikerModel>.deserializeModelArrayFrom(array: dicAry) as! [PikerModel]
    }()
    
    
    
    @IBOutlet weak var headerImageBtn: UIButton!
    @IBOutlet weak var contentVIew: UIView!
    @IBAction func clickAddBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickFillInfoViewHeader, object: nil, info: nil)
    }
    let titleAry:[String] = ["昵称","约会范围","年龄","身份","身高","体重","胸围"]
    var subTitle:[String] = [CurrentUserInfo?.nickname ?? "","","","","CM","KG","CM"];
    
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.frame = CGRect.init(x: 0, y: 45, width: ScreenWidth - 16, height: self.contentVIew.frame.height - 45)
        table.isScrollEnabled = false
        self.contentVIew.addSubview(table)
        return table
        
    }()
    var tagFrame:CGRect?
    
    override func draw(_ rect: CGRect) {
        self.frame = tagFrame!
    }
    
    class func createFillInfoView(frame:CGRect) -> FillInfoView?
    {
        let nibVIew = CustomCreateNib<FillInfoView>().createXibView()
        guard let view = nibVIew else {
            return nil
        }
        view.creatContentView()
        view.tagFrame = frame
        view.headerImageBtn.layer.cornerRadius = view.headerImageBtn.frame.width / 2.0
        view.headerImageBtn.clipsToBounds = true
        view.contentVIew.layer.cornerRadius = 5.0
        view.contentVIew.clipsToBounds = true
        if let imageUrl = CurrentUserInfo?.avatar,imageUrl.count > 0 {
            view.headerImageBtn.imageView?.sd_DownLoadImage(url: imageUrl)
        }
        
        return view
    }
    
    
    func creatContentView() {
        self.tableView.isHidden = false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FillInfoViewCell")
        if  cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "FillInfoViewCell")
            
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
            {
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            
            
        }
        let cellTitle = titleAry[indexPath.row]
        let subCellTitle = subTitle[indexPath.row]
        cell?.textLabel?.text = cellTitle
        cell?.detailTextLabel?.text = subCellTitle
        return cell!
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.zzy.router(name: FillInfoViewClick, object: nil, info: indexPath.row)
        
        let titleStr = titleAry[indexPath.row]
        switch indexPath.row {
        case 0:
           
            AlertAction.share.showAlertView(type: nil,title: titleStr, placeHodel: "请输入昵称",textStr:nil, detailTitle: nil, detailImage: nil, click: { (sure, result) in
                if sure {
                    self.replaceStr(str: result, index: indexPath.row)
                }
            })
            break
        case 1://约会范围
            AlertAction.share.showbottomPicker(title: titleStr, maxCount: 4, dataAry: currentCitys, currentData: self.oppintRange, backData: { (result) in
                self.oppintRange = result
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
            })
            break
        case 2://年龄
            var currentData:[String] = []
            
            if let agestr = self.age,agestr.count > 0
            {
                currentData = [agestr]
            }
            
            AlertAction.share.showbottomPicker(title: titleStr, maxCount: 1, dataAry: ageList, currentData: currentData, backData: { (result) in
                self.age = result.last
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
            })
            break
        case 3://身份
            var currentData:[String] = []
            if let agestr = self.identity,agestr.count > 0
            {
                currentData = [agestr]
            }
            AlertAction.share.showbottomPicker(title: titleStr, maxCount: 1, dataAry: FillCondition.share.identityListModel, currentData: currentData, backData: { (result) in
                self.identity = result.last
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
            })
            break
        case 4://身高
            AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,title: titleStr, placeHodel: "请输入身高CM", textStr:nil,detailTitle: nil, detailImage: nil, click: { (sure, result) in
                if sure {
                    self.bodyHeight = result
                    let str = result?.appending("CM")
                    self.replaceStr(str: str, index: indexPath.row)
                }
            })
            break
        case 5://体重
            AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,title: titleStr, placeHodel: "请输入体重KG",textStr:nil, detailTitle: nil, detailImage: nil, click: { (sure, result) in
                if sure {
                    self.bodyWeight = result
                    let str = result?.appending("KG")
                    self.replaceStr(str: str, index: indexPath.row)
                }
            })
            break
        case 6:
            AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,title: titleStr, placeHodel: "请输入胸围CM",textStr:nil, detailTitle: nil, detailImage: nil, click: { (sure, result) in
                if sure {
                    self.bodyChest = result
                    let str = result?.appending("CM")
                    self.replaceStr(str: str, index: indexPath.row)
                }
            })
            break
            
        default: break
            
        }
        
    }
    func replaceStr(str:String?,index:Int) {
        self.subTitle.remove(at: index)
        self.subTitle.insert(str ?? "", at: index)
        tableView.reloadData()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
