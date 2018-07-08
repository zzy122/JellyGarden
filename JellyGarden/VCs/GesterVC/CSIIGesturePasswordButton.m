//
//  CSIIGesturePasswordButton.m
//  CSIIGesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "CSIIGesturePasswordButton.h"


@implementation CSIIGesturePasswordButton
@synthesize selected;
@synthesize success;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (selected) {
        if (success) {
            
            CGContextSetRGBStrokeColor(context, 152/255.f, 182/255.f, 225/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,84/255.f, 131/255.f, 203/255.f,1);

        }
        else {
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,1);

        }
        CGRect frame = CGRectMake(self.bounds.size.width/2-self.bounds.size.width/8+1, self.bounds.size.height/2-self.bounds.size.height/8, self.bounds.size.width/4, self.bounds.size.height/4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
        
        CGContextSetRGBStrokeColor(context, 222/255.f, 222/255.f, 222/255.f,1);//初始状态圆圈颜色
    }
    // 96 199 255
    CGContextSetLineWidth(context,2);
//    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGRect frame = CGRectMake(15, 15, self.bounds.size.width-30, self.bounds.size.height-30);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (success) {
        CGContextSetRGBFillColor(context,1.f, 1.f, 1.f,0.1);//内部填充
    }
    else {
        
        
        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
    }
    CGContextAddEllipseInRect(context,frame);
    if (selected) {
        CGContextFillPath(context);
    }
    else
    {
//        CGContextSetRGBFillColor(context, 96/255.f, 199/255.f, 255/255.f,1);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    
}


@end
