//
//  EnlistDetailViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class EnlistDetailViewController: BaseMainTableViewController {

    var detaileModel:lonelySpeechDetaileModel?
    var signModels:[sign_up]?
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "报名详情"
        self.detaileModel?.need_signup = 0//取消查看报名等按钮
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
        self.tableView.register(UINib.init(nibName: "EnlistDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EnlistDetailTableViewCell")
        self.getSinUpModel()
        // Do any additional setup after loading the view.
    }
    func getSinUpModel()
    {
        TargetManager.share.getAppiontDetail(appointment_id: detaileModel?.appointment_id ?? "") { (model, error) in
            guard let model1 = model?.sign_up ,model1.count > 0 else
            {
               return
            }
            self.signModels = model1
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
extension EnlistDetailViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else
        {
            return signModels?.count ?? 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
            cell.setDatasource(model: detaileModel ?? lonelySpeechDetaileModel())
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnlistDetailTableViewCell", for: indexPath) as! EnlistDetailTableViewCell
        cell.model = signModels?[indexPath.row]
        return cell
            
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let viewLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 1 / scale))
            viewLine.backgroundColor = APPCustomGrayColor
            
            
            let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50))
            view1.backgroundColor = UIColor.white
            view1.addSubview(viewLine)
            
            
            let lable = creatLable(frame: CGRect.init(x: 10, y: 20, width: 100, height: 20), title: "报名人员", font: kFont_system13, textColor: nil)
            lable.backgroundColor = UIColor.clear
            view1.addSubview(lable)
            return view1
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return caculateCellHeight(model: detaileModel!)
        }
        return 110
    }
}
