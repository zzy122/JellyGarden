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
@property(nonatomic,strong)UITapGestureRecognizer* pictureTap;
@end
@implementation ReadDestroyCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight
{
    return CGSizeMake(collectionViewWidth, 100*[UIScreen mainScreen].bounds.size.width / 320.0 + extraHeight + 40);
    
}

- (void)longGester:(UILongPressGestureRecognizer*)gester
{
    if (gester.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didLongTouchMessageCell:inView:)]) {
            [self.delegate didLongTouchMessageCell:self.model inView:self.view];
        }
    }
    else if (gester.state == UIGestureRecognizerStateFailed || gester.state == UIGestureRecognizerStateCancelled || gester.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
            [self.delegate didTapMessageCell:self.model];
        }
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [ReadDestroryView getReadDestroryView];
        self.view.tagRect = CGRectMake(0, 0, 100 * [UIScreen mainScreen].bounds.size.width / 320.0, 100 * [UIScreen mainScreen].bounds.size.width / 320.0);
        
        [self.messageContentView addSubview:self.view];
        [self.view addGestureRecognizer:self.pictureTap];
        
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
    ReadDestroyMessage* mes = (ReadDestroyMessage*)model.content;
    self.view.mess = mes;
    
    if ([mes.isRead isEqualToNumber:@(0)]) {
        [self.view addGestureRecognizer:self.gester];
    }
    else
    {
        [self.view removeGestureRecognizer:self.gester];
       
    }
    self.nicknameLabel.hidden = YES;
    [self setAutoLayout];
    
}
- (void)tapPicture:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
- (UITapGestureRecognizer *)pictureTap
{
    if (_pictureTap == nil) {
        _pictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
        _pictureTap.numberOfTapsRequired = 1;
        _pictureTap.numberOfTouchesRequired = 1;
    }
    return _pictureTap;
}
- (UILongPressGestureRecognizer *)gester
{
    UILongPressGestureRecognizer* ge = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGester:)];
    return ge;
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
