//
//  ReadDestroryView.m
//  JellyGarden
//
//  Created by zzy on 2018/6/25.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ReadDestroryView.h"
@interface ReadDestroryView()
@property(nonatomic,strong)UILongPressGestureRecognizer* gester;
@end
@implementation ReadDestroryView

+ (ReadDestroryView*)getReadDestroryView
{
    
    
    ReadDestroryView* view = (ReadDestroryView*)[[NSBundle mainBundle] loadNibNamed:@"ReadDestroryView" owner:nil options:nil].firstObject;
    return view;
    
}
- (UILongPressGestureRecognizer *)gester
{
    UILongPressGestureRecognizer* ge = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGester:)];
    return ge;
}

- (void)longGester:(UILongPressGestureRecognizer*)gester
{
    if (gester.state == UIGestureRecognizerStateEnded || gester.state == UIGestureRecognizerStateCancelled || gester.state == UIGestureRecognizerStateFailed) {
        [self removeGestureRecognizer:gester];
    }
    if (gester.state == UIGestureRecognizerStateBegan) {
        //查看图片
        int function = 0;
        
    }
}
- (void)drawRect:(CGRect)rect
{
    self.frame = self.tagRect;
    [self addGestureRecognizer:self.gester];
}
- (void)setMess:(ReadDestroyMessage *)mess
{
    _mess = mess;
    if ([mess.isRead isEqualToNumber:@(0)]) {
        self.TapLab.hidden = NO;
        self.titleLable.text = @"阅后即焚";
        self.tagImagV.image = [UIImage imageNamed:@""];
    }
    else
    {
        [self removeGestureRecognizer:self.gester];
        self.TapLab.hidden = YES;
        self.titleLable.text = @"已焚毁";
        self.tagImagV.image = [UIImage imageNamed:@""];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
