//
//  DepositMessageCell.h
//  JellyGarden
//
//  Created by zzy on 2018/6/2.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "DepositView.h"
@interface DepositMessageCell : RCMessageCell<RCMessageCellDelegate>
@property(nonatomic,strong)DepositView* posView;
//@property(nonatomic,strong)UILabel* StautLable;
@end
