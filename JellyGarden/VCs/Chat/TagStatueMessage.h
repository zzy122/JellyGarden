//
//  TagStatueMessage.h
//  JellyGarden
//
//  Created by zzy on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//
#import <RongIMKit/RongIMKit.h>
//#import <RongIMLib/RongIMLib.h>

@interface TagStatueMessage : RCMessageContent <NSCoding>
/*!
 初始化测试消息
 
 @param content 文本内容
 @return        测试消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;
@end
