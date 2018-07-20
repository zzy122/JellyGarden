//
//  CommentNotifyViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CommentNotifyViewController: BaseMainTableViewController {

    let dicAry = [["type":"text","content":"联系过你的用户对你评价了: ","corlor":"black","size":14],["type":"text","content":"没意思,难约\n","color":"blue","size":14],["type":"text","content":"如果评价不属实,您可申请上诉,我们会进行核实.","corlor":"black","size":14]]
    let config = ZZYFramParserConfig()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价通知"
        tableView.register(UINib.init(nibName: "CommentNotyfyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentNotyfyTableViewCell")
        config.lineSpace = 15
        config.isCenter = false
        config.width = ScreenWidth - 95
        // Do any additional setup after loading the view.
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
extension CommentNotifyViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentNotyfyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentNotyfyTableViewCell", for: indexPath) as! CommentNotyfyTableViewCell
        let textData = ZZYFrameParser.parseContent(dicAry, config: config)
        cell.commentView.data = textData
        cell.contentHeight.constant = textData?.height ?? 0
        cell.timeLab.text = "2小时前"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textData = ZZYFrameParser.parseContent(dicAry, config: config)
        return (textData?.height ?? 0 ) + 110
        
    }
}
