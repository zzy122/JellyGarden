//
//  ReadDestroyCell.m
//  JellyGarden
//
//  Created by zzy on 2018/6/25.
//  Copyright © 2018年 zzy. All rights reserved.
//
#import "ReadDestroyMessage.h"
#import "ReadDestroyCell.h"
#import "ReadDestroryView.h"
@interface ReadDestroyCell()
@property(nonatomic,strong)ReadDestroryView* view;
@property(nonatomic,strong)UILongPressGestureRecognizer* gester;
@end
@implementation ReadDestroyCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight
{
    return CGSizeMake(collectionViewWidth, 80*[UIScreen mainScreen].bounds.size.width / 320.0);
    
}

- (void)longGester:(UILongPressGestureRecognizer*)gester
{
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [ReadDestroryView getReadDestroryView];
        self.view.tagRect = CGRectMake(0, 0, 70 * [UIScreen mainScreen].bounds.size.width / 320.0, 70 * [UIScreen mainScreen].bounds.size.width / 320.0);
        
        [self.messageContentView addSubview:self.view];
        
        
    }
    return self;
}
- (void)setDataModel:(RCMessageModel *)model
{
    ReadDestroyMessage* mes = (ReadDestroyMessage*)model.content;
    model.conversationType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    model.isDisplayMessageTime = YES;
    model.isDisplayNickname = false;
    model.readReceiptInfo.isReceiptRequestMessage = YES;//消息回执
    [super setDataModel:model];
    self.view.mess = mes;
    
    self.nicknameLabel.hidden = YES;
    
    if ([model.content isKindOfClass:[ReadDestroyMessage class]]) {
        [self setAutoLayout];
        UIView* view = (UIView*)self.portraitImageView;
        view.hidden = YES;
        
    }
    
}
- (void)setAutoLayout {
    
    CGRect messageContentViewRect = self.messageContentView.frame;
    if (self.messageDirection == MessageDirection_SEND) {
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width - (self.view.tagRect.size.width + HeadAndContentSpacing +
                                                  [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
    }
}
- (void)didTapMessageCell:(RCMessageModel *)model
{
    NSLog(@"点击了我");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
