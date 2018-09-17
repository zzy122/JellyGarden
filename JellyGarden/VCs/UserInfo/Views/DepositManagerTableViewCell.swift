//
//  DepositManagerTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let DepositManagerBottomBtn = "DepositManagerBottomBtn"
class DepositManagerTableViewCell: UITableViewCell {


    @IBOutlet weak var statusLab: UILabel!

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var sureAppiontBtn: UIButton!
    @IBOutlet weak var payAccountLab: UILabel!
    @IBOutlet weak var appiontTimeLab: UILabel!
    @IBOutlet weak var payTimelab: UILabel!
    @IBOutlet weak var nickLab: UILabel!
    @IBOutlet weak var headerImag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model: DepositListModel?
    {
        didSet{
            nickLab.text  = model?.user_name
            payTimelab.text =  timeStampToDate(time: model?.pay_time ?? 0, backType: DateFormatterType.day)
            payAccountLab.text = model?.pay_money
            statusLab.text = model?.status
            appiontTimeLab.text =  timeStampToDate(time: model?.yue_time ?? 0, backType: DateFormatterType.day)
        }
    }
    override func layoutSubviews() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        headerImag.layer.cornerRadius = 25
        headerImag.clipsToBounds = true
        statusLab.addCorners(roundCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomLeft.rawValue) | UInt8(UIRectCorner.topLeft.rawValue))), cornerSize: CGSize.init(width: 8, height: 8))
//        if CurrentUserInfo?.sex == 1
//        {
//            self.sureAppiontBtn.isHidden = true
//            self.lineView.isHidden = true
//        }
        
    }
    
    @IBAction func clickSureAppiontBtn(_ sender: UIButton) {
        zzy.router(name: DepositManagerBottomBtn, object: nil, info: model)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
