//
//  DepositView.m
//  JellyGarden
//
//  Created by zzy on 2018/6/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "DepositView.h"

@implementation DepositView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self createView];
    self.userInteractionEnabled = YES;
    return  self;
}
- (void)createView{
    self.backgroundColor = [UIColor colorWithRed:1.0 green:151 / 255.0 blue:0 alpha:1];
    UIImageView* imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订金"]];
    imv.frame = CGRectMake(15, 10, 34, 34);
    imv.layer.cornerRadius = 15;
    [self addSubview:imv];
    self.amountLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame) + 8, CGRectGetMinY(imv.frame), 200, 18)];
    _amountLab.backgroundColor = [UIColor clearColor];
    _amountLab.textColor = [UIColor whiteColor];
    _amountLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:_amountLab];
    
    
    UILabel* subLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 18)];
    subLab.text = @"  订单支付红包";
    subLab.backgroundColor = [UIColor whiteColor];
    subLab.textColor = [UIColor grayColor];
    subLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:subLab];
    
    UILabel*detailLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame) + 8, CGRectGetMaxY(imv.frame) - 18, 200, 18)];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor whiteColor];
    detailLab.font = [UIFont systemFontOfSize:11];
    detailLab.text = @"支付定金";
    [self addSubview:detailLab];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
