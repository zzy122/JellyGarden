//
//  TagStatueCell.m
//  JellyGarden
//
//  Created by zzy on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "TagStatueCell.h"
#import "TagStatueMessage.h"
@implementation TagStatueCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight
{
    return CGSizeMake(collectionViewWidth, 60);

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.StautLable = [UILabel new];
        
        _StautLable.frame = CGRectMake(0, 0, frame.size.width, 20);
        _StautLable.layer.cornerRadius = 10;
        _StautLable.clipsToBounds = YES;
        _StautLable.backgroundColor = [UIColor grayColor];
        _StautLable.font = [UIFont systemFontOfSize:12];
        _StautLable.textColor = [UIColor whiteColor];
        _StautLable.layer.cornerRadius = 9.0;
        _StautLable.textAlignment = NSTextAlignmentCenter;
        [self.messageContentView addSubview:self.StautLable];
        
      
    }
    return self;
}
- (void)setDataModel:(RCMessageModel *)model
{
    model.conversationType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    model.isDisplayMessageTime = YES;
    model.isDisplayNickname = false;
    model.readReceiptInfo.isReceiptRequestMessage = YES;//消息回执
    
    [super setDataModel:model];
    
    self.nicknameLabel.hidden = YES;
    
    if ([model.content isKindOfClass:[TagStatueMessage class]]) {
        [self setAutoLayout];
        UIView* view = (UIView*)self.portraitImageView;
        view.hidden = YES;
        
    }
    
}
- (void)setAutoLayout {
    
    CGRect statusLabFrame = self.StautLable.frame;
    NSString * str = self.getStuateStr;
    
    self.StautLable.hidden = YES;
    //拉伸图片
    self.messageContentView.frame = self.bounds;
    self.StautLable.hidden = NO;
    CGFloat width =   [self getStuateWidthStr:str withFont:[UIFont systemFontOfSize:13]];
    statusLabFrame = CGRectMake((CGRectGetWidth(self.contentView.bounds) - width) / 2.0, statusLabFrame.origin.y, width, statusLabFrame.size.height);
    self.StautLable.frame = statusLabFrame;
    self.StautLable.text = str;
}
- (void)didTapMessageCell:(RCMessageModel *)model
{
    NSLog(@"点击了我");
}

- (NSString*)getStuateStr
{
    NSString * str = nil;
    if (self.model.messageDirection == MessageDirection_RECEIVE)
    {
        str = [NSString stringWithFormat:@"%@支付了你发起的定金",self.model.content.senderUserInfo.name];
    }
    else
    {
        str = [NSString stringWithFormat:@"你支付了%@发起的定金",self.model.userInfo.name];
    }
    
    return str;
}

- (CGFloat)getStuateWidthStr:(NSString*)str withFont:(UIFont*)font
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width + 8;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
