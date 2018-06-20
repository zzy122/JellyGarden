//
//  DepositMessageCell.m
//  JellyGarden
//
//  Created by zzy on 2018/6/2.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "DepositMessageCell.h"
#import "DepositMessage.h"
@implementation DepositMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight
{
    CGFloat messageContentHeight = 70;
    return CGSizeMake(collectionViewWidth, messageContentHeight += extraHeight);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.posView = [[DepositView alloc]initWithFrame:self.contentView.bounds];
        self.StautLable = [UILabel new];
        
        
        _StautLable.backgroundColor = [UIColor grayColor];
        _StautLable.font = [UIFont systemFontOfSize:12];
        _StautLable.textColor = [UIColor whiteColor];
        _StautLable.layer.cornerRadius = 9.0;
        [self.contentView addSubview:self.StautLable];
        [self.baseContentView addSubview:self.posView];
    }
    return self;
}
- (void)setModel:(RCMessageModel *)model
{
    if ([model.content isKindOfClass:[DepositMessage class]]) {
        DepositMessage* message = (DepositMessage*)model.content;
        self.posView.amountLab.text = [self getAmountStr:message.amotStr];
         NSString* title = [self getStuateStr];
        CGFloat width = [self getStuateWidthStr:title withFont:self.StautLable.font];
        self.StautLable.text = title;
        self.StautLable.frame = CGRectMake(CGRectGetMaxX(self.baseContentView.frame) - width, CGRectGetMaxY(self.baseContentView.frame) + 10, width, 18);
        self.StautLable.hidden = YES;
       
        
    }
}
- (NSString*)getStuateStr
{
    
    NSString* str = [NSString stringWithFormat:@"你支付了%@发起的定金",self.model.userInfo.name];
    return str;
}
- (NSString*)getAmountStr:(NSString*)amount
{
    return [NSString stringWithFormat:@"定金 ¥ %@",amount];
}
- (CGFloat)getStuateWidthStr:(NSString*)str withFont:(UIFont*)font
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width + 8;
}
@end
