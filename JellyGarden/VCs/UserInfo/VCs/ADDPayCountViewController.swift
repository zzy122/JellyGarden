//
//  ADDPayCountViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/3.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ADDPayCountViewController: BaseMainTableViewController {
    lazy var rightControls:[UITextField] = {
        var ary:[UITextField] = []
        let text = self.createTextFiled()
        text.placeholder = "输入支付宝账号"
        let text2 = self.createTextFiled()
        text2.placeholder = "输入姓名"
        ary.append(text)
        ary.append(text2)
        return ary
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加支付宝账号"
        self.edgesForExtendedLayout = UIRectEdge.bottom
        // Do any additional setup after loading the view.
    }
    func createTextFiled() -> UITextField {
        let text = UITextField.init(frame: CGRect.init(x: ScreenWidth - 160, y: 10, width: 150, height: 30))
        text.borderStyle = .none
        text.textAlignment = NSTextAlignment.right
        text.font = kFont_Normal
        text.backgroundColor = UIColor.clear
        return text
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.isHidden = false
        rightBtn.setTitle("确定", for: UIControlState.normal)
        rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
    }
    override func clickRightBtn() {
        guard let accountStr = rightControls.first?.text else
        {
            alertHud(title: "请输入支付宝账号")
            return
        }
        guard let nameStr = rightControls.last?.text else
        {
            alertHud(title: "请输入支付宝名字")
            return
        }
        
        TargetManager.share.addAlipayAccount(params: ["user_id":CurrentUserInfo?.user_id ?? "","account":accountStr,"name":nameStr]) { (result) in
            if result == true {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension ADDPayCountViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ADDPayCountViewController")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "ADDPayCountViewController")
            if indexPath.row == 0
            {
                cell?.textLabel?.text = "支付宝账号"
            }
            else {
                cell?.textLabel?.text = "姓名(保密内容,防止汇错)"
            }
            cell?.contentView.addSubview(rightControls[indexPath.row])
            
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
   
    
}

