//
//  CommentNotifyViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CommentNotifyViewController: BaseMainTableViewController {

    var dicAry:[Any]? //[["type":"text","content":"联系过你的用户对你评价了: ","corlor":"black","size":14],["type":"text","content":"没意思,难约\n","color":"blue","size":14],["type":"text","content":"如果评价不属实,您可申请上诉,我们会进行核实.","corlor":"black","size":14]]
    
    
    let config = ZZYFramParserConfig()
    var models:[EvaluateNoticeModel]?
    {
        didSet{
            if let tagModel = models ,tagModel.count > 0
            {
                var ary:[Any] = []
                for i:Int in 0 ..< tagModel.count
                {
                    let model = tagModel[i]
                    let dic:[Any] = [["type":"text","content":"\(model.user_name ?? "")对你评价了: ","corlor":"black","size":14],["type":"text","content":"\(model.content ?? "")\n","color":"blue","size":14],["type":"text","content":"如果评价不属实,您可申请上诉,我们会进行核实.","corlor":"black","size":14]]
                    ary.append(dic)
                }
                self.dicAry = ary
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价通知"
        tableView.register(UINib.init(nibName: "CommentNotyfyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentNotyfyTableViewCell")
        config.lineSpace = 15
        config.isCenter = false
        config.width = ScreenWidth - 95
        self.requesCommentNotifyModel()
        // Do any additional setup after loading the view.
    }
    func requesCommentNotifyModel()
    {
        TargetManager.share.requestEvaluateNotice{ (models, error) in
            self.models = models
            self.tableView.reloadData()
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
extension CommentNotifyViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dicAry?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentNotyfyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentNotyfyTableViewCell", for: indexPath) as! CommentNotyfyTableViewCell
        let model:EvaluateNoticeModel = (models?[indexPath.row])!
        let textData = ZZYFrameParser.parseContent(dicAry![indexPath.row] as! [Any], config: config)
        cell.commentView.data = textData
        
        cell.contentHeight.constant = textData?.height ?? 0
        cell.timeLab.text = distanceTime(time: model.time)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textData = ZZYFrameParser.parseContent(dicAry![indexPath.row] as! [Any], config: config)
//        return (textData?.height ?? 0 ) + 110
        return (textData?.height ?? 0 ) + 60
    }
}
