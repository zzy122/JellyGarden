//
//  APPNotifyViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class APPNotifyViewController: BaseMainTableViewController {

    
    let testStr = "此处没接口测试此处没接口测试此处没接口测试此处没接口测"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "果冻花园"
        self.tableView.register(UINib.init(nibName: "AppNotifyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "AppNotifyTableViewCell")
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//         self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
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
extension APPNotifyViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AppNotifyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppNotifyTableViewCell", for: indexPath) as! AppNotifyTableViewCell
        cell.contentLab.text = testStr
        cell.timeLab.text = "1小时前"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return testStr.zzy.caculateHeight(font: kFont_system15, width: ScreenWidth - 95, lineSpace: 8) + 60
    }

    
}
