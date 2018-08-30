//
//  ConfessionTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickCommentCell = "ClickCommentCell"
class ConfessionTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    lazy var tableView:UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        view.isScrollEnabled = false
        view.separatorStyle = UITableViewCellSeparatorStyle.none
        view.register(UINib.init(nibName: "CommentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentTableViewCell")
        
        self.contentView.addSubview(view)
        return view
    }()
    lazy var headerBackView:UIView = {
        
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50))
        view1.backgroundColor = UIColor.clear
        self.headerView = ConfessionTableViewCellHeader.createConfessionTableViewCellHeader()
        self.headerView?.frame = view1.bounds

        view1.addSubview(self.headerView!)
        self.contentView.addSubview(view1)
        return view1
    }()
    var headerView:ConfessionTableViewCellHeader?
    
    lazy var bodyBackView:UIView = {
        let view1 = UIView.init(frame: CGRect.init(x: 10, y: self.headerBackView.frame.maxY + 10, width: ScreenWidth - 20, height: getBodyheight()))
        
        view1.backgroundColor = UIColor.clear
        self.bodyView = ConfessionTableViewCellBody.createConfessionTableViewCellBody()
        self.bodyView?.frame = view1.bounds
        
        view1.addSubview(self.bodyView!)
        self.contentView.addSubview(view1)
        return view1
        
    }()
    func getBodyheight() -> CGFloat {
        let oringinTopX:CGFloat = ((self.tagModel?.requirement ?? "").zzy.caculateHeight(font: kFont_system15, width: ScreenWidth - 40, lineSpace: 8)) + 41//计算高度
        
        guard  let imageNameAry = tagModel?.attachment,imageNameAry.count > 0 else {
            
            return oringinTopX
        }        
        let intege = getLines(ary: imageNameAry, veryCount: 4)
        
        return oringinTopX + CGFloat(intege) * (BodyImageHeight + 10)
    }
    var bodyView:ConfessionTableViewCellBody?
    
    
    
    
    lazy var applyBackView:UIView = {
        let view1 = UIView()
        view1.backgroundColor = UIColor.clear
        self.applyView = ApplyOperationView.createApplyOperationView()
        
        view1.addSubview(self.applyView!)
        self.contentView.addSubview(view1)
        return view1
    }()
    
    var applyView:ApplyOperationView?

    
    var tagModel:lonelySpeechDetaileModel?
    
    var isEnableDelete:Bool = false
    {
        didSet{
            if isEnableDelete == false
            {
                self.headerView?.deleteBtn.isHidden = true
                self.headerView?.leftMargin.constant = 10
            }
        }
    }
    var detailModel:lonelySpeechDetaileModel? {
        didSet{
            self.bodyBackView.frame = CGRect.init(x: 10, y: self.headerBackView.frame.maxY + 10, width: ScreenWidth - 20, height: getBodyheight())
            self.bodyView?.frame = self.bodyBackView.bounds
            
            self.applyBackView.frame = CGRect.init(x: 0, y: self.bodyBackView.frame.maxY, width: ScreenWidth, height: 45)
            self.applyView?.frame = self.applyBackView.bounds
            
            let imageUrl = detailModel?.avatar ?? ""
            DebugLog(message: "头像地址:\(imageUrl)")

            self.headerView?.headerImage.sd_DownLoadImage(url: imageUrl)
            self.headerView?.headerImage.image = imageName(name: detailModel?.avatar ?? "")
            let sexStr = (detailModel?.sex == 0) ? "男1" : "女1"
            self.headerView?.nikeName.text = detailModel?.user_name
            self.headerView?.sexImage.image = imageName(name: sexStr)
            self.headerView?.authTrueLab.backgroundColor = APPCustomRedColor
            if let has_authentication = detailModel?.has_authentication ,has_authentication
            {
                //未认证
                self.headerView?.authTrueLab.text = "真实"
            }
            else
            {
                //未认证
                self.headerView?.authTrueLab.text = "未认证"
                self.headerView?.authTrueLab.backgroundColor = UIColor.gray
            }
            self.headerView?.publishLab.text = "发布于\(timeStampToDate(time: (detailModel?.add_time)!, backType: .second))"
            self.headerView?.LikeBtn.setImage(imageName(name: "赞"), for: UIControlState.normal)
            if let taglike = detailModel?.is_like,taglike == true  {
                self.headerView?.LikeBtn.setImage(imageName(name: "赞-press"), for: UIControlState.normal)
            }
            
           
            
            let countStr = ((detailModel?.like.count ?? 0) > 0) ? String.init(format: "%d", detailModel?.like.count ?? 0) : ""
            self.headerView?.LikeBtn.setTitle("\(countStr)", for: UIControlState.normal)
            self.commentAry = detailModel?.comments ?? []
            self.applyView?.lookApplayBtn.setTitle(String.init(format: "查看报名(%d)", detailModel?.sign_up_count ?? 0), for: UIControlState.normal)
            
            if let isend = detailModel?.is_overdue, isend == false
            {
                self.applyView?.ApplyStatus.setTitle("我要报名", for: UIControlState.normal)
                self.applyView?.ApplyStatus.setTitleColor(APPCustomRedColor, for: UIControlState.normal)
                self.applyView?.ApplyStatus.isUserInteractionEnabled = true
            }
            else
            {
                self.applyView?.ApplyStatus.isUserInteractionEnabled = false
                self.applyView?.ApplyStatus.setTitle("已结束", for: UIControlState.normal)
                self.applyView?.ApplyStatus.setTitleColor(UIColor.gray, for: UIControlState.normal)
            }
           

            if detailModel?.need_signup == false
            {
                self.applyBackView.isHidden = true
                
            }
           
            if (detailModel?.user_id != CurrentUserInfo?.user_id) || (isEnableDelete == false)  {
                
                self.headerView?.deleteBtn.isHidden = true
                self.headerView?.leftMargin.constant = 10
            }
            else
            {
                self.headerView?.leftMargin.constant = 60
                self.headerView?.deleteBtn.isHidden = false
            }
            
        
            
        }
    }
    override func setNeedsLayout() {
        if (detailModel?.user_id != CurrentUserInfo?.user_id) || (isEnableDelete == false)  {
            self.headerView?.deleteBtn.isHidden = true
            self.headerView?.leftMargin.constant = 10
        }
    }
    
    var commentAry:[commentsModel] = [] {
        didSet{
            self.applyView?.bottomView.isHidden = false
            if commentAry.count == 0 {
                self.applyView?.bottomView.isHidden = true
                self.tableView.isHidden = true
                return
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }//评论的数据
    
    
    func setTableViewFrame(view:UITableView) {
        var height:CGFloat = 0.0
        for model in self.commentAry
        {
            height = height + CommentGetHeight.getHeightCell(title: model.publisher_name ?? "", commentStr: model.content ?? "") + 5
        }
        if detailModel?.need_signup == true
        {
            view.frame = CGRect.init(x: 0, y: self.applyBackView.frame.maxY, width: ScreenWidth, height: height)
        }
        else
        {
            view.frame = CGRect.init(x: 0, y: self.bodyBackView.frame.maxY, width: ScreenWidth, height: height)
        }
    }
    
    func setDatasource(model:lonelySpeechDetaileModel) {
        self.tagModel = model
        self.headerBackView.isHidden = false
        self.bodyBackView.isHidden = false
        
        self.applyBackView.isHidden = false
        self.applyView?.tag = self.tag
        self.headerView?.tag = self.tag
        self.detailModel = model
        self.bodyView?.setDatasource(model: model)
        self.bodyView?.tag = self.tag
        self.setTableViewFrame(view: self.tableView)
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ConfessionTableViewCell
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        let model:commentsModel = self.commentAry[indexPath.row]
        let nickName = model.publisher_name ?? ""
        cell.title = nickName
        cell.nickNameLab.text = nickName
        cell.commentLab.text = model.content ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:commentsModel = self.commentAry[indexPath.row]
        return CommentGetHeight.getHeightCell(title: model.publisher_name ?? "", commentStr: model.content ?? "") + 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.zzy.router(name: ClickCommentCell, object: nil, info: indexPath.row)
    }
    
}

