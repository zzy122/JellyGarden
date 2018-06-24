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
    return CGSizeMake(collectionViewWidth, messageContentHeight + extraHeight + 20);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.posView = [[DepositView alloc]initWithFrame:CGRectMake(0, 0, 180*[UIScreen mainScreen].bounds.size.width / 320.0, 80)];
        self.StautLable = [UILabel new];
        
        _StautLable.frame = CGRectMake(0, CGRectGetMaxY(self.messageContentView.frame), frame.size.width, 20);
        _StautLable.layer.cornerRadius = 10;
        _StautLable.clipsToBounds = YES;
        _StautLable.backgroundColor = [UIColor grayColor];
        _StautLable.font = [UIFont systemFontOfSize:12];
        _StautLable.textColor = [UIColor whiteColor];
        _StautLable.layer.cornerRadius = 9.0;
        _StautLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.StautLable];
        [self.messageContentView addSubview:self.posView];
    }
    return self;
}
- (void)setDataModel:(RCMessageModel *)model
{
    [super setDataModel:model];
    [self setAutoLayout];
    
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
- (void)setAutoLayout {
    DepositMessage *testMessage = (DepositMessage *)self.model.content;
    if (testMessage) {
        self.posView.amountLab.text = [NSString stringWithFormat:@"定金 %@",testMessage.amotStr];
    }
    
    CGRect messageContentViewRect = self.messageContentView.frame;
    CGRect statusLabFrame = self.StautLable.frame;
    NSString * str = nil;
    self.StautLable.hidden = YES;
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {//接收方 不用改变frame
        
        str = [NSString stringWithFormat:@"你支付了%@发起的定金",self.model.userInfo.name];
        
        
    } else {
        str = [NSString stringWithFormat:@"%@支付了你发起的定金",self.model.userInfo.name];
        
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width - (self.posView.frame.size.width + HeadAndContentSpacing +
                                                  [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
    }
    self.posView.amountLab.text = [self getAmountStr:testMessage.amotStr];
    if (testMessage.isPay != 0)
    {
        self.StautLable.hidden = NO;
        CGFloat width =   [self getStuateWidthStr:str withFont:[UIFont systemFontOfSize:13]];
        statusLabFrame = CGRectMake((CGRectGetWidth(self.contentView.bounds) - width) / 2.0, statusLabFrame.origin.y, width, statusLabFrame.size.height);
        self.StautLable.frame = statusLabFrame;
        self.StautLable.text = str;
    }
    
    
}
- (void)didTapMessageCell:(RCMessageModel *)model
{
    NSLog(@"点击了我");
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
