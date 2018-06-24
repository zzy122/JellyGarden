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
         
        
    }
}
- (void)setAutoLayout {
    DepositMessage *testMessage = (DepositMessage *)self.model.content;
    if (testMessage) {
        self.posView.amountLab.text = [NSString stringWithFormat:@"定金 %@",testMessage.amotStr];
    }
    
    CGRect messageContentViewRect = self.messageContentView.frame;
  
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {//接收方 不用改变frame
        
        
    } else {
        
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width - (self.posView.frame.size.width + HeadAndContentSpacing +
                                                  [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
    }
    self.posView.amountLab.text = [self getAmountStr:testMessage.amotStr];
    
    
}

- (NSString*)getAmountStr:(NSString*)amount
{
    return [NSString stringWithFormat:@"定金 ¥ %@",amount];
}
@end
