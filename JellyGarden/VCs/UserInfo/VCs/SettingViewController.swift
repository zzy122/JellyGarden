//
//  SettingViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/3.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SettingViewController: BaseMainTableViewController {
    let lefttitles:[String] = ["修改密码","设置app开锁密码","消息推送设置","清除图片缓存"]
    var imageCatch:Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
       self.getMemorySize()
        self.edgesForExtendedLayout = UIRectEdge.bottom
        // Do any additional setup after loading the view.
    }
    func getMemorySize()
    {
        KingfisherManager.shared.cache.calculateDiskCacheSize { (size) in
            DispatchQueue.main.async {
                self.imageCatch = Float(size)
                self.tableView.reloadData()
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
extension SettingViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lefttitles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewController")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "SettingViewController")
        }
        cell?.textLabel?.text = lefttitles[indexPath.row]
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        if indexPath.row == lefttitles.count - 1
        {
           cell?.detailTextLabel?.text = String.init(format: "%.1fM", imageCatch / Float(1024 * 1024))
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == lefttitles.count - 1
        {
            ImageCache.default.clearDiskCache()
            ImageCache.default.clearMemoryCache()
            let str = String.init(format: "%.1fM", imageCatch / Float(1024 * 1024))
            alertHud(title: "已为你清理\(str)")
            self.getMemorySize()
        }
        else if indexPath.row == 1
        {
            let vc:CSIIGesturePasswordController = CSIIGesturePasswordController().initwithType(InitializeType.set, withState: { (issuccess) in
                if issuccess {
                    NeedGesterPassword = true
                }
            })
            vc.isLunch = true
            vc.gesturePasswordView.logoimgView.sd_DownLoadImage(url: CurrentUserInfo?.data?.avatar ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 0 {
            self.navigationController?.pushViewController(XiugaiPasswordViewController(), animated: true)
        }
        else if indexPath.row == 2 {
            self.navigationController?.pushViewController(MessagePushSettingViewController(), animated: true)
            
        }
    }
}
