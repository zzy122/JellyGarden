//
//  MainpersonInfoHeader.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ManpersonInfoHeader: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var introduceContentLab: UILabel!
    @IBOutlet weak var troduceLab: UILabel!
    @IBOutlet weak var ImageContentView: UIView!
    @IBOutlet weak var userInfoContentView: UIView!
    @IBOutlet weak var attestationDetailLab: UILabel!//通过了安全认证
    @IBOutlet weak var attestationLab: UILabel!//可靠  未认证
    @IBOutlet weak var cityLab: UILabel!//约会范围
    @IBOutlet weak var distanceLab: UILabel!//距离
    @IBOutlet weak var detailLab: UILabel!//地址所在地 年龄 职业
    @IBOutlet weak var nikeNameLab: UILabel!//昵称
    @IBOutlet weak var headerImage: UIImageView!
    var tagFrame:CGRect?
    var imageAry:[String] = []//照片数量
    
    override func draw(_ rect: CGRect) {
        
    }
    override func layoutSubviews() {
        self.frame = tagFrame!
        if self.imageAry.count == 0 {
            self.collectonView.isHidden = true
            return
        }
        self.collectonView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.ImageContentView.frame.minY - 80)
    }
    lazy var collectonView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 8.0
        layout.itemSize = CGSize.init(width: (self.ImageContentView.frame.width - 3 * margin) / 4.0, height: BodyImageHeight)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//
        
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let view = UICollectionView.init(frame: self.ImageContentView.bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.register(UINib.init(nibName: "BodyImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BodyImageCollectionViewCell")
        view.delegate = self;
        view.isScrollEnabled = false
        view.bounces = false
        view.dataSource = self
        self.ImageContentView.addSubview(view)
        return view
    }()
    class func createManpersonInfoHeader() -> ManpersonInfoHeader?{
        let nibView = CustomCreateNib<ManpersonInfoHeader>().createXibView()
        guard let view = nibView else {
            return nil
        }
        //        view.backgroundColor = UIColor.clear
        view.headerImage.layer.cornerRadius = 35
        view.headerImage.clipsToBounds = true
        view.collectonView.isHidden = false
        view.userInfoContentView.clipsToBounds = true
        view.userInfoContentView.layer.cornerRadius = 8
        view.attestationLab.layer.cornerRadius = 8.0
        view.attestationLab.clipsToBounds = true
        return view
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension ManpersonInfoHeader
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyImageCollectionViewCell", for: indexPath) as? BodyImageCollectionViewCell
        
        cell?.setImage(image: imageName(name: "loginicon"), isImplement: LookImageType.effect)
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RootNav().pushViewController(LookImageViewController(), animated: true)
    }
}
