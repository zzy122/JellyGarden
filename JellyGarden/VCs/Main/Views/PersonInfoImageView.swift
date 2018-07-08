//
//  PersonInfoImageView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/20.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class PersonInfoImageView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    lazy var implementView:UIView = {
        let beffe = UIView.init(frame: self.bounds)
        beffe.alpha = 0.5
        beffe.backgroundColor = k_CustomColor(red: 10, green: 27, blue: 65)
        self.addSubview(beffe)
        
        return beffe
    }()
    lazy var warmLab:UILabel = {
        let lable = creatLable(frame: CGRect.init(x: 0, y: self.frame.height / 2.0 - 20, width: self.frame.width, height: 20), title: "他设置了付费相册", font: kFont_SmallNormal, textColor: UIColor.white)
        lable.textAlignment = NSTextAlignment.center
        lable.backgroundColor = UIColor.clear
        self.addSubview(lable)
        return lable
    }()
    lazy var deblockBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: self.center.x - 60, y: self.frame.height / 2.0 + 5, width: 120, height: 30))
        btn.backgroundColor = APPCustomBtnColor
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = kFont_SmallNormal
        btn.addTarget(self, action: #selector(clickDeblockingBtn), for: UIControlEvents.touchUpInside)
        self.addSubview(btn)
        return btn
        
    }()
    
    var userModel:UserInfo? {
        didSet{
            self.collectonView.reloadData()
        }
    }
    var itemHeight = BodyImageHeight
    override func layoutSubviews() {
        if userModel?.permission == permissionAry[1] && userModel?.user_id != CurrentUserInfo?.data?.user_id {
            self.implementView.isHidden = false
            warmLab.text = "她设置了付费相册"
            self.deblockBtn.setTitle("解锁她的相册", for: UIControlState.normal)
        }
        self.collectonView.frame = self.bounds
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var collectonView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 8.0
        layout.itemSize = CGSize.init(width: (self.frame.width - 3 * margin) / 4.0, height: itemHeight)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//
        
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let view = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.register(UINib.init(nibName: "BodyImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BodyImageCollectionViewCell")
        view.delegate = self;
        view.isScrollEnabled = false
        view.bounces = false
        view.dataSource = self
        self.addSubview(view)
        return view
    }()
    @objc func clickDeblockingBtn(){
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension PersonInfoImageView
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.userModel?.photos?.count ?? 0
        return (userModel?.user_id == CurrentUserInfo?.data?.user_id) ? (count + 1) : count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyImageCollectionViewCell", for: indexPath) as? BodyImageCollectionViewCell
        
        if indexPath.row != self.userModel?.photos?.count
        {
            cell?.setImage(imageStr: self.userModel?.photos?[indexPath.row] ?? "", isImplement: LookImageType.clearness)
        }
        else//是本人资料 设置添加按钮可以添加照片
        {
            cell?.setImage(imageStr: "添加照片-1", isImplement: LookImageType.clearness)
            cell?.imageV.image = imageName(name: "添加照片-1")
        }
        
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != self.userModel?.photos?.count
        {
            RootViewController?.hideTheTabbar()
            let vc = LookImageViewController()
            vc.imageUrl = userModel?.photos?[indexPath.row] ?? ""
            
            RootNav().pushViewController(vc, animated: true)
        }
        else//是本人资料 设置添加按钮点击事件可以添加照片
        {
            zzy.router(name: ClickFirstPhoto, object: nil, info: nil)
        }
        
        
        
    }
}
