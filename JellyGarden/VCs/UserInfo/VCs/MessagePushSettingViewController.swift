//
//  MessagePushSettingViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let checkMaterial = "checkMaterial"
let checkContact = "checkContact"
let checkPacket = "checkPacket"
let sendContact = "sendContact"
let newCast = "newCast"
let privateChat = "privateChat"
let stateList:[String] = {
    if CurrentUserInfo?.sex == 0 {
        return [checkMaterial,checkPacket,newCast,privateChat]
    }
    return [checkMaterial,checkContact,checkPacket,sendContact,newCast,privateChat]
    
}()
class MessagePushSettingViewController: BaseMainTableViewController {
    
    
    var leftSterings:[String] = {
        if CurrentUserInfo?.sex == 1 {
            return ["有男士申请查看我的资料页","有男士付款查看我的联系方式","有男士付费查看我的红包照片","有已付费查看约会的男士给我发送联系方式","有新的广播","私聊"]
        }
        else
        {
           return ["有女士申请查看我的资料页","有女士付费查看我的红包照片","有新的广播","私聊"]
        }
        
    }()
    var currentState:[Bool] =
    {
        var sta:[Bool] = []
        for i in 0 ..< stateList.count
        {
            
            sta.append(UserDefaults.standard.bool(forKey: stateList[i]))
        }
        return sta
    }()
    
    
    var states:[Bool] = {
        var sta:[Bool] = []
        for i in 0 ..< stateList.count
        {
            
            sta.append(UserDefaults.standard.bool(forKey: stateList[i]))
        }
        return sta
    }()
    func getState(name:String) ->Bool
    {
        return UserDefaults.standard.bool(forKey:name)
    }
    func setState(name:String,state:Bool)
    {
        UserDefaults.standard.set(state, forKey: name)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息推送设置"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.setTitle("保存", for: UIControlState.normal)
        rightBtn.isHidden = false
    }
    override func clickRightBtn() {
        for i in 0 ..< currentState.count
        {
            setState(name: stateList[i], state: currentState[i])
        }
        alertHud(title: "保存成功")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createSwitchBtn() ->UISwitch
    {
        let swt = UISwitch.init(frame: CGRect.init(x: ScreenWidth - 80, y: 10, width: 60, height: 30))
        swt.onTintColor = APPCustomBtnColor
        return swt
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
extension MessagePushSettingViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftSterings.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MessagePushSettingViewController")
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "MessagePushSettingViewController")
            let swit = createSwitchBtn()
            swit.tag = indexPath.row + 1
            swit.addTarget(self, action: #selector(clickSwitch(swt:)), for: UIControlEvents.valueChanged)
            cell?.contentView.addSubview(swit)
        }
        let swit = cell?.contentView.viewWithTag(indexPath.row + 1) as? UISwitch
        swit?.isOn = states[indexPath.row]
        cell?.textLabel?.text = leftSterings[indexPath.row]
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    @objc func clickSwitch(swt:UISwitch)
    {
        currentState.replaceSubrange((swt.tag - 1)..<swt.tag, with: [swt.isOn])
    }
    
}
