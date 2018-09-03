//
//  ZZYDisplayView.m
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ZZYDisplayView.h"
#import "UIResponder+Router.h"
@interface ZZYDisplayView()

@end
@implementation ZZYDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    UITapGestureRecognizer* tapGester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelf:)];
    [self addGestureRecognizer:tapGester];
    
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
}
- (void)clickSelf:(UITapGestureRecognizer*)gester
{
    CGPoint point = [gester locationInView:self];
    if (self.data.imageAry.count > 0) {
        [self.data.imageAry enumerateObjectsUsingBlock:^(ImageStyle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = obj.imagePosition;
            CGPoint imagePoint = frame.origin;
            imagePoint.y = self.bounds.size.height - obj.imagePosition.size.height - obj.imagePosition.origin.y;
            CGRect rect = CGRectMake(imagePoint.x, imagePoint.y, frame.size.width, frame.size.height);
            if (CGRectContainsPoint(rect, point)) {
                [self routerWithName:CLICKIMAGE withObjt:[NSNumber numberWithInteger:idx]];
            }
        }];
    }
    if (self.data.rangeAry.count > 0) {
        [self.data.rangeAry enumerateObjectsUsingBlock:^(ZZYLinkTextData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self clickLinkData:obj point:point];
            
        }];
        
    }
}
- (void)clickLinkData:(ZZYLinkTextData*)link point:(CGPoint)point
{
    CTFrameRef textFram = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFram);
    if (!lines) {
        return;
    }
    CFIndex count = CFArrayGetCount(lines);//计算总共有多少行
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFram, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1, -1);
    for (int i = 0; i < count; i++) {//遍历每一行
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedrect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedrect, transform);//某个Rect通过矩阵变换之后的区域
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            if (NSLocationInRange(index, link.rang)) {
                link.clickTag();
                return;
            }
        }
    }
    
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0;
    CGFloat descent = 0.0;
    CGFloat leading = 0.0;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);//获取上行高度下行高度 行距
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

- (void)setData:(ZZYCoreTextData *)data
{
    _data = data;
    [self.data.imageAry enumerateObjectsUsingBlock:^(ImageStyle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addImageViewWithModel:obj];
    }];
}

- (void)addImageViewWithModel:(ImageStyle*)model
{
    UIImageView* iMV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:model.name]];
    iMV.frame = CGRectMake(model.imagePosition.origin.x, self.data.height - model.imagePosition.size.height - model.imagePosition.origin.y, model.imagePosition.size.width, model.imagePosition.size.height);
    [self addSubview:iMV];
}
@end
