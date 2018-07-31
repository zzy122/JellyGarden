//
//  DisAgreeRefundView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
//let Click_DepositDisAgree_CancelBtn = "Click_DepositDisAgree_CancelBtn"
//let Click_DepositAcgree_CancelBtn = "Click_DepositAgree_CancelBtn"
class DisAgreeRefundView: UIView {
    
    typealias clickResult = (Bool,[UIImage]?,String?) -> Void
//    var imageData:[Any]?
    var clickBtnBlock:clickResult?
    var images:[Image] = []
    {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var instructiontext: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func layoutSubviews() {
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "BodyImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BodyImageCollectionViewCell")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func createDisAgreeRefundView() -> DisAgreeRefundView
    {
        let nibView = CustomCreateNib<DisAgreeRefundView>().createXibView()
        return nibView!
    }
    @IBAction func clickAgreeBtn(_ sender: UIButton) {
        clickBtnBlock?(true,images,instructiontext.text)
        
    }
    @IBAction func clickDisAgreeBtn(_ sender: UIButton) {
        clickBtnBlock?(false,images,instructiontext.text)
    }
}
extension DisAgreeRefundView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyImageCollectionViewCell", for: indexPath) as! BodyImageCollectionViewCell
        if indexPath.row == images.count
        {
            cell.setImage(imageStr: "添加照片-1", isImplement: LookImageType.clearness,image:nil)
            cell.imageV.image = imageName(name: "添加照片-1")
        }
        else
        {
            cell.setImage(imageStr: nil, isImplement: .clearness, image: images[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count
        {
            let vc = TZImagePickerController.init(maxImagesCount: 4, delegate: self)
            vc?.allowPickingVideo = false
            vc?.allowPickingImage = true
            vc?.allowTakePicture = true
            vc?.didFinishPickingPhotosHandle = {(photos, assets, isSelectOriginalPhoto) in
                guard let  ims = photos else{
                    return
                }
                self.images =  self.images + ims
            }
            RootNav().present(vc!, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.bounds.width
        let itemWidth = (width - 2 * 15) / 3.0
        return CGSize.init(width: itemWidth, height: itemWidth)
    }
}
extension DisAgreeRefundView:TZImagePickerControllerDelegate
{
    
    
}
