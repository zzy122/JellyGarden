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
        layout.itemSize = CGSize.init(width: (self.frame.width - 6 * margin) / 4.0, height: BodyImageHeight)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//
        
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let view = UICollectionView.init(frame: self.imageContentView.bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.register(UINib.init(nibName: "BodyImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BodyImageCollectionViewCell")
        view.delegate = self;
        view.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        view.isScrollEnabled = false
        view.bounces = false
        view.dataSource = self
        self.imageContentView.addSubview(view)
        return view
    }()
    

    class func createConfessionTableViewCellBody() -> ConfessionTableViewCellBody? {
        let nibView = CustomCreateNib<ConfessionTableViewCellBody>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.dingJinBtn.layer.cornerRadius = 13
        view.dingJinBtn.clipsToBounds = true
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        return view
    }
    func setDatasource(model:lonelySpeechDetaileModel) {
        let titleStr = "\(timeStampToDate(time: model.create_at ?? 0,backType: .day))·\(model.city ?? "")"
        
        self.timeLocalLab.text = titleStr
        self.describtionLab.text = model.requirement ?? ""
        self.imageNameAry = model.attachment ?? []

        self.collectonView.isHidden = false
        self.collectonView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height - describtionLab.frame.maxY)
        self.collectonView.reloadData()
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNameAry?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyImageCollectionViewCell", for: indexPath) as? BodyImageCollectionViewCell
        cell?.setImage(imageStr: imageNameAry?[indexPath.row] ?? "", isImplement: LookImageType.clearness)
      
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RootViewController?.hideTheTabbar()
        let vc = LookImageViewController()
        vc.imageUrl = imageNameAry?[indexPath.row] ?? ""
        
        RootNav().pushViewController(vc, animated: true)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
