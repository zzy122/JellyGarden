//
//  ReadDestroryView.m
//  JellyGarden
//
//  Created by zzy on 2018/6/25.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ReadDestroryView.h"
@interface ReadDestroryView()
@end
@implementation ReadDestroryView

+ (ReadDestroryView*)getReadDestroryView
{
    
    
    ReadDestroryView* view = (ReadDestroryView*)[[NSBundle mainBundle] loadNibNamed:@"ReadDestroryView" owner:nil options:nil].firstObject;
    return view;
    
}



- (void)drawRect:(CGRect)rect
{
    self.frame = self.tagRect;
}
- (void)layoutSubviews
{
    self.frame = self.tagRect;
}
- (void)setMess:(ReadDestroyMessage *)mess
{
    _mess = mess;
    if (mess.isRead != nil) {
        if ([mess.isRead isEqualToNumber:@(0)]) {
            self.TapLab.hidden = NO;
            self.titleLable.text = @"阅后即焚";
            self.tagImagV.image = [UIImage imageNamed:@""];
        }
        else
        {
            self.TapLab.hidden = YES;
            self.titleLable.text = @"已焚毁";
            self.tagImagV.image = [UIImage imageNamed:@""];
        }
    }
   
}


@end
