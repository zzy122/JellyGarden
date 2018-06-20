//
//  ZZYTimerTarget.h
//  test
//
//  Created by zzy on 2018/5/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZYTimerTarget : NSObject
@property(nonatomic,weak)id target;

- (instancetype)initWithTarget:(id)target;
@end
