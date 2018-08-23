//
//  SetRedPacketPhotoViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/27.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SetRedPacketPhotoViewController: BaseMainViewController {

    lazy var collectionView:UICollectionView =
        {
        let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize.init(width: (ScreenWidth - 4 * 15) / 3.0, height:  (ScreenWidth - 4 * 15) / 3.0)
            layout.minimumLineSpacing = 15
            layout.scrollDirection = UICollectionViewScrollDirection.vertical
            layout.minimumInteritemSpacing = 15
            let scroll = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
            scroll.contentInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 0, right: 15)
            scroll.delegate = self
            scroll.backgroundColor = UIColor.white
            scroll.register(UINib.init(nibName: "SetRedpacketCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SetRedpacketCollectionViewCell")
            scroll.dataSource = self
            return scroll
    }()
    var selectModel:PhotoModel?
    var dataAry:[PhotoModel]?
    {
        get {
              return CurrentUserInfo?.custom_photos
        }
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.view.addSubview(self.collectionView)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.setTitle("确定", for: UIControlState.normal)
        rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        rightBtn.isHidden = false
        self.title = "设置红包照片"
    }
    override func viewDidLayoutSubviews() {
        collectionView.frame = self.view.bounds
    }
    override func clickRightBtn() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setRedPacketImage()
    {
        guard let model = self.selectModel else {
            alertHud(title: "你没有选择红包图片")
            return
        }
        MM_WARNING
        //设置红包图片接口
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
extension SetRedPacketPhotoViewController:UICollectionViewDelegate,UICollectionViewDataSource,ResponderRouter,UICollectionViewDelegateFlowLayout
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickSelected_RedPacket//设置红包照片
        {
            let indexTag = info as! Int
            self.selectModel = self.dataAry?[indexTag]
            let cells = self.collectionView.visibleCells as! [SetRedpacketCollectionViewCell]
            for cell in cells
            {
                cell.tagBtn.isSelected = false
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataAry?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SetRedpacketCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetRedpacketCollectionViewCell", for: indexPath) as! SetRedpacketCollectionViewCell
        let model:PhotoModel = self.dataAry![indexPath.row]
        if model.url != self.selectModel?.url
        {
            cell.model = model
        }
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: ScreenWidth - 4 * 15, height: ScreenWidth - 4 * 15)
//    }
}


