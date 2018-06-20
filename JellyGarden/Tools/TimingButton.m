//
//  TimingButton.m
//  test
//
//  Created by zzy on 17/2/27.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import "TimingButton.h"
//#import "ReactiveObjC.h"
//#import "NSTimer+Run.h"
#import "ZZYTimerTarget.h"
@interface TimingButton()
@property(nonatomic,assign)NSInteger timeTotal;
@property(nonatomic,strong)NSTimer* timer;


@end

@implementation TimingButton
-(instancetype)init
{
    if (self = [super init]) {
        [self setButtonStyle];
        
    }
    return self;
}
- (void)setButtonStyle
{
    self.timeTotal = 60;
    self.layer.borderWidth = 1;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.layer.borderColor = [UIColor redColor].CGColor;
    [self setTitle:@"获取" forState:UIControlStateNormal];
}
- (void)starTime
{
    self.timeTotal = 60;
    ZZYTimerTarget* timeTarget = [[ZZYTimerTarget alloc]initWithTarget:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:timeTarget selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //使用rac
//    self.disable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
//        [self timerAction];
//
//    }];
    
    
}
- (void)timerAction
{
    
    self.timeTotal--;
    self.userInteractionEnabled = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"(%zi)",self.timeTotal];
    [self setTitle:[NSString stringWithFormat:@"(%zi)",self.timeTotal] forState:UIControlStateNormal];
    if (self.timeTotal == 0) {
        [self stopTime];
    }
}
-(void)stopTime
{

    [self.timer invalidate];
    [self setTitle:@"重新发送" forState:UIControlStateNormal];
    self.timeTotal = 60;
    self.userInteractionEnabled = YES;
}
-(void)dealloc
{
    [self.timer invalidate];
    NSLog(@"按钮释放了");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
