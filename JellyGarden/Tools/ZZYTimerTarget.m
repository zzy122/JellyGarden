//
//  ZZYTimerTarget.m
//  test
//
//  Created by zzy on 2018/5/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ZZYTimerTarget.h"
#import <objc/runtime.h>
@implementation ZZYTimerTarget
- (instancetype)initWithTarget:(id)target
{
    self.target = target;
    return self;
}
/*
 这个函数让重载方有机会抛出一个函数的签名，再由后面的forwardInvocation:去执行
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.target methodSignatureForSelector:aSelector];
}

/*
 将消息转发给其他对象，这里转发给控制器
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel =[anInvocation selector];
    if ([self.target respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:self.target];
    }
}

//- (void)zzyTimerTargetAction:(NSTimer *)timer
//{
//    if (self.target) {
//        IMP imp = [self.target methodForSelector:self.selector];
//
//        void (*func)(id,SEL,NSTimer*) = (void*)imp;
//        func(self.target,self.selector,timer);
//    }
//    else
//    {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}
@end
