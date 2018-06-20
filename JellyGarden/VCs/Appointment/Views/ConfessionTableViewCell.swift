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
//        forBaselineLayout()
//       self.setTableViewFrame(view: view)
        
        self.contentView.addSubview(view)
        return view
    }()
    var type:AppiontCellType = .mainList {
        didSet{
            if type == .mainList {
               self.applyView.isHidden = false
                
            }
            else
            {
                self.applyView.isHidden = true
            }
        }
    }
    
    var detailModel:lonelySpeechDetaileModel? {
        didSet{
            self.headerView.headerImage.image = imageName(name: detailModel?.poster?.avatar ?? "")
            let sexStr = (detailModel?.poster?.sex! == 0) ? "男1" : "女1"
            
            self.headerView.sexImage.image = imageName(name: sexStr)
            self.headerView.authTrueLab.backgroundColor = APPCustomRedColor
            if let has_authentication = detailModel?.poster?.has_authentication ,has_authentication
            {
                //未认证
                self.headerView.authTrueLab.text = "真实"
            }
            else
            {
                //未认证
                self.headerView.authTrueLab.text = "未认证"
                self.headerView.authTrueLab.backgroundColor = UIColor.gray
            }
            self.headerView.publishLab.text = "发布于\(timeStampToDate(time: detailModel?.create_at ?? 0, backType: .second))"
            self.headerView.LikeBtn.setImage(imageName(name: "赞"), for: UIControlState.normal)
            if let taglike = detailModel?.is_like,taglike == true  {
                self.headerView.LikeBtn.setImage(imageName(name: "赞-press"), for: UIControlState.normal)
            }
            
            let countStr = ((detailModel?.likes_count ?? 0) > 0) ? String.init(format: "%d", (detailModel?.likes_count)!) : ""
            self.headerView.LikeBtn.setTitle("\(countStr)", for: UIControlState.normal)
            self.commentAry = detailModel?.comments ?? []
            
        }
    }
    
    
    var commentAry:[commentsModel] = [] {
        didSet{
            self.applyView.bottomView.isHidden = false
            if commentAry.count == 0 {
                self.applyView.bottomView.isHidden = true
                self.tableView.isHidden = true
                return
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }//评论的数据
    
    
    lazy var bodyView:ConfessionTableViewCellBody = {
        let view = ConfessionTableViewCellBody.createConfessionTableViewCellBody(frame: CGRect.init(x: 10, y: self.headerView.tagFrame.maxY + 10, width: ScreenWidth - 20, height: 30))
        self.contentView.addSubview(view!)
        self.backgroundColor = UIColor.white
        return view!
    }()
    lazy var headerView:ConfessionTableViewCellHeader = {
        let view = ConfessionTableViewCellHeader.createConfessionTableViewCellHeader()
        view?.tagFrame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50)
        self.contentView.addSubview(view!)
        view?.tag = self.tag
        return view!
    }()
    lazy var applyView:ApplyOperationView = {
        let view = ApplyOperationView.createApplyOperationView()
        view?.tagFrame = CGRect.init(x: 0, y: self.bodyView.tagFrame.maxY, width: ScreenWidth, height: 45)
        view?.tag = self.tag
        self.contentView.addSubview(view!)
        return view!
    }()
    
    func setTableViewFrame(view:UITableView) {
        var height:CGFloat = 0.0
        for model in self.commentAry
        {
            height = height + CommentGetHeight.getHeightCell(title: model.publisher_name ?? "", commentStr: model.content ?? "") + 5
        }
        if self.type == .mainList
        {
            view.frame = CGRect.init(x: 0, y: self.applyView.tagFrame.maxY, width: ScreenWidth, height: height)
        }
        else
        {
            view.frame = CGRect.init(x: 0, y: self.bodyView.tagFrame.maxY, width: ScreenWidth, height: height)
        }
    }
    
    func setDatasource(type:AppiontCellType,model:lonelySpeechDetaileModel) {
        
        self.headerView.isHidden = false
        self.bodyView.isHidden = false
        self.bodyView.setDatasource(model: model)
        self.applyView.isHidden = false
        self.type = type
        self.detailModel = model
        
        

    }
//    override func draw(_ rect: CGRect) {
//        self.setOrigiY()
//    }
    override func layoutSubviews() {
        self.setOrigiY()
    }
    func setOrigiY()  {
        self.applyView.tagFrame = CGRect.init(x: 0, y: self.bodyView.tagFrame.maxY, width: ScreenWidth, height: 45)
        self.setTableViewFrame(view: self.tableView)
        self.headerView.setNeedsDisplay()//重新布局
        self.bodyView.setNeedsDisplay()//重新布局
        self.applyView.setNeedsDisplay()//重新布局
    }
    func getCellHeight() -> CGFloat {
        let topHeight:CGFloat = 50
        let bodyHeight = self.bodyView.getBodyheight()
        return topHeight + bodyHeight
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
        cell.nickNameLab.text = "\(model.publisher_name ?? ""):"
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

