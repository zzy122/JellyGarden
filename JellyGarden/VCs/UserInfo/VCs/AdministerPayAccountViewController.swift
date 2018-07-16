//
//  AdministerPayAccountViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AdministerPayAccountViewController: BaseMainTableViewController {
    var indexTag:Int = 0
    var alipayModels:[AlipayModel]?
    {
        didSet {
            self.tableView.reloadData()
        }
    }
    var backSelectModel:((AlipayModel) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理支付宝账号"
        tableView.register(UINib.init(nibName: "PayAccountTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PayAccountTableViewCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.edgesForExtendedLayout = UIRectEdge.bottom
        // Do any additional setup after loading the view.
    }
    func getAlipayModel()
    {
        TargetManager.share.getAlipayAccount(params: ["user_id":CurrentUserInfo?.data?.user_id ?? ""]) { (models, error) in
            if (models?.count ?? 0) > 0
            {
                self.alipayModels = models
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.isHidden = false
//        self.tableView.isEditing = true
        rightBtn.setTitle("添加", for: UIControlState.normal)
        rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        self.getAlipayModel()
    }
    override func clickRightBtn() {
        RootNav().pushViewController(ADDPayCountViewController(), animated: true)
    }
    override func clickLeftBtn() {
        self.backSelectModel?((alipayModels?[indexTag])!)
        
        self.navigationController?.popViewController(animated: true)
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
extension AdministerPayAccountViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return alipayModels?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PayAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PayAccountTableViewCell", for: indexPath) as! PayAccountTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.imageTag.image = imageName(name: "未选中")
        cell.contentbackView.layer.cornerRadius = 5
        cell.contentbackView.clipsToBounds = true
        cell.model = alipayModels?[indexPath.section]
        if indexPath.section == indexTag
        {
            cell.imageTag.image = imageName(name: "选中")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexTag = indexPath.section
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vie1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 15))
        vie1.backgroundColor = UIColor.clear
        return vie1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let alipay_account_id = alipayModels?[indexPath.section].alipay_account_id ?? ""
        TargetManager.share.deleteAlipayAccount(alipay_account_id: alipay_account_id) { (success) in
            if success{
                tableView.beginUpdates()
                self.alipayModels?.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: UITableViewRowAnimation.fade)
                tableView.endUpdates()
                
//                tableView.reloadData()
            }
        }
    }
    
}
