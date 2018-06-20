//
//  ConfessionTableViewCellBody.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ConfessionTableViewCellBody: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var dingJinBtn: UIButton!
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var describtionLab: UILabel!
    @IBOutlet weak var timeLocalLab: UILabel!
    var describtion:String?
    var imageNameAry:[String]?
    
    
    lazy var collectonView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 10.0
        layout.itemSize = CGSize.init(width: (self.tagFrame.width - 6 * margin) / 4.0, height: BodyImageHeight)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//
        
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let view = UICollectionView.init(frame: self.imageContentView.bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.register(UINib.init(nibName: "BodyImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BodyImageCollectionViewCell")
        view.delegate = self;
        view.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
//        view.isScrollEnabled = false
        view.bounces = false
        view.dataSource = self
        self.imageContentView.addSubview(view)
        return view
    }()
    
    
    var tagFrame:CGRect = CGRect.zero
    override func draw(_ rect: CGRect) {
        self.frame = self.tagFrame
//        self.collectonView.isHidden = false
    }
    class func createConfessionTableViewCellBody(frame:CGRect) -> ConfessionTableViewCellBody? {
        let nibView = CustomCreateNib<ConfessionTableViewCellBody>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.dingJinBtn.layer.cornerRadius = 13
        view.dingJinBtn.clipsToBounds = true
        view.tagFrame = frame
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        return view
    }
    func setDatasource(model:lonelySpeechDetaileModel) {
//        timeLocalStr:String,describtionStr:String,imageAry:[String]
        let titleStr = "\(timeStampToDate(time: model.create_at ?? 0,backType: .day))·\(model.city ?? "")"
        
        self.timeLocalLab.text = titleStr
        self.describtionLab.text = model.requirement ?? ""
        self.imageNameAry = model.attachment ?? []
        self.tagFrame = CGRect.init(x: self.tagFrame.origin.x,  y: 60, width: tagFrame.width, height: self.getBodyheight())
        self.collectonView.isHidden = false
        self.collectonView.frame = CGRect.init(x: 0, y: 0, width: self.tagFrame.width, height: self.tagFrame.height - describtionLab.frame.maxY)
        self.collectonView.reloadData()
        
    }
    
    func getBodyheight() -> CGFloat {
        let oringinTopX:CGFloat = (self.describtionLab.text?.zzy.caculateHeight(font: kFont_system15, width: self.tagFrame.width - 20, lineSpace: 8))! + 10 + self.timeLocalLab.frame.maxY//计算高度
        
        if imageNameAry?.count == 0 {
            return oringinTopX
        }
        
        let intege = getLines(ary: imageNameAry!, veryCount: 4)
       
        return oringinTopX + CGFloat(intege) * (BodyImageHeight + 10)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNameAry?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyImageCollectionViewCell", for: indexPath) as? BodyImageCollectionViewCell
        cell?.setImage(image: imageName(name: "loginicon"), isImplement: LookImageType.clearness)
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RootViewController?.hideTheTabbar()
        RootNav().pushViewController(LookImageViewController(), animated: true)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
