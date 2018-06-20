//
//  FillInformationViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class FillInformationViewController: BaseTableViewController {
    var fillInfo:[String:Any] = [:]
    
    let dataAry:[[String:Any]] = {
        return [["content":["打扮风格","语言","感情","约会节目","约会条件"]],["content":["QQ","微信"]]]
    }()
    lazy var stepView:StepView = {
        let view = StepView.createStepView(step: 2)
        view?.tagFram = CGRect.init(x: 50, y: 70, width: ScreenWidth - 100, height: 20)
        return view!
    }()
    var subTitle:[String] = ["","","","",""]
    
    var currentDressStyle:[String] = []//装扮
    var currentLualages:[String] = []//语言
    var currentEmotion:String = ""//情感
    var currentOppiontProgram:[String] = []//约会节目
    var currentOppiontConditions:[String] = []//选择的约会条件
    lazy var textAry:[UITextField] = {
        let text1 = self.createTextFiled(frame: CGRect.init(x: 65, y: 10, width: ScreenWidth - 70, height: 30))
        let text2 = self.createTextFiled(frame: CGRect.init(x: 65, y: 10, width: ScreenWidth - 50, height: 30))
        return [text1,text2]
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "完善资料"
        let headerBackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 140))
        headerBackView.backgroundColor = UIColor.clear
        headerBackView.addSubview(self.stepView)
        self.tableView.tableHeaderView = headerBackView
        
        
        let footBackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 130))
        footBackView.backgroundColor = UIColor.clear
        let btn = createCustomBtn(frame: CGRect.init(x: 30, y: footBackView.frame.height - BTNHEIGHT, width: ScreenWidth - 60, height: BTNHEIGHT), sel: #selector(clickNextBtn(sender:)), target: self, title: "下一步")
        footBackView.addSubview(btn)
        self.tableView.tableFooterView = footBackView
        // Do any additional setup after loading the view.
    }
    @objc func clickNextBtn(sender:UIButton)
    {
        if currentDressStyle.count == 0 {
            alertHud(title: "请选择打扮风格")
           return
        }
        if currentLualages.count == 0 {
            alertHud(title: "请选择语言")
            return
        }
        if currentEmotion.count == 0 {
            alertHud(title: "请选择情感")
            return
        }
        if currentOppiontProgram.count == 0 {
            alertHud(title: "请选择约会节目")
            return
        }
        if currentOppiontConditions.count == 0 {
            alertHud(title: "请选择约会条件")
            return
        }
        
        if currentDressStyle.count == 0 {
            alertHud(title: "请选择打扮风格")
            return
        }
        if textAry.first?.text?.count == 0 && textAry.last?.text?.count == 0  {
            alertHud(title: "至少填写一种联系方式")
            return
        }
//        let dressAryJson = getJSONStringFromObject(dictionary: currentDressStyle)
//        let lagugeJson = getJSONStringFromObject(dictionary: currentLualages)
//        let appiontParagramJson = getJSONStringFromObject(dictionary: currentOppiontProgram)
//        let appiontConditionJson = getJSONStringFromObject(dictionary: currentOppiontConditions)
        
        fillInfo["emotion_status"] = currentEmotion
        fillInfo["appointment_condition"] = currentOppiontConditions
        fillInfo["appointment_program"] = currentOppiontProgram
        fillInfo["language"] = currentLualages
        fillInfo["dress_style"] = currentDressStyle
        
        if let qqStr = textAry.first?.text,qqStr.count > 0 {
            fillInfo["contact_qq"] = qqStr
            fillInfo["contact_wechat"] = ""
        }
        if let wechatStr = textAry.last?.text,wechatStr.count > 0 {
            
            fillInfo["contact_wechat"] = wechatStr
        }
        
        let thirdVC = FillInformationThirdViewController()
        thirdVC.fillInfo = fillInfo
        self.navigationController?.pushViewController(thirdVC, animated: true)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dic = dataAry[section]["content"] as? [Any] {
            return dic.count
        }
        return 0
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            let cell1 = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            if indexPath.section == 0 {
                
                cell1.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
               
            }
            else
            {
                cell1.contentView.addSubview(self.textAry[indexPath.row])
            }
            cell = cell1
        }
        cell?.detailTextLabel?.text = ""
        if indexPath.section == 0{
             cell?.detailTextLabel?.text = subTitle[indexPath.row]
        }
        
        let ary = dataAry[indexPath.section]["content"] as! [String]
        cell?.textLabel?.text = ary[indexPath.row]
        
        return cell!
    }
    func createTextFiled(frame:CGRect) -> UITextField {
        let text = APPTextfiled()
        text.frame = frame
        text.borderStyle = UITextBorderStyle.none
        return text
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
            backView.backgroundColor = UIColor.clear
            let lable = creatLable(frame: CGRect.init(x: 10, y: 10, width: 200, height: 30), title: "联系方式(至少写一种联系方式)", font: kFont_SmallNormal, textColor: UIColor.gray)
            lable.backgroundColor = UIColor.clear
            
            backView.addSubview(lable)
            return backView
        }
        return nil
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            return
        }
        let titleAry:[String] = self.dataAry[indexPath.section]["content"]! as! [String]
        let title:String = titleAry[indexPath.row] 
        
        
        switch indexPath.row {
        case 0:
            AlertAction.share.showbottomPicker(title: title, maxCount: 4, dataAry: FillCondition.share.dressStyleListModel, currentData: currentDressStyle, backData: { (result) in
                self.currentDressStyle = result
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
                
            })
            break
        case 1:
            AlertAction.share.showbottomPicker(title: title, maxCount: 1, dataAry: FillCondition.share.languageListModel, currentData: currentLualages, backData: { (result) in
                self.currentLualages = result
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
                
            })
            break
        case 2:
            AlertAction.share.showbottomPicker(title: title, maxCount: 1, dataAry: FillCondition.share.emotionStatusList, currentData: [currentEmotion], backData: { (result) in
                self.currentEmotion = result.last ?? ""
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
                
            })
            break
        case 3:
            AlertAction.share.showbottomPicker(title: title, maxCount: 4, dataAry: FillCondition.share.appointmentProgramListModel, currentData: currentOppiontProgram, backData: { (result) in
                self.currentOppiontProgram = result
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
                
            })
            break
        case 4:
            AlertAction.share.showbottomPicker(title: title, maxCount: 4, dataAry: FillCondition.share.appointmentConditionListModel, currentData: currentOppiontConditions, backData: { (result) in
                self.currentOppiontConditions = result
                self.replaceStr(str: continueString(strAry: result,separetStr:"  "), index: indexPath.row)
                
            })
            break
        case 5:
            break
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0.0
    }
    func replaceStr(str:String?,index:Int) {
        self.subTitle.remove(at: index)
        self.subTitle.insert(str ?? "", at: index)
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
