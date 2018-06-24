//
//  RCDTestMessage.h
//  RCloudMessage
//
//  Created by 岑裕 on 15/12/17.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 测试消息的类型名
 */
#define RCDTestMessageTypeIdentifier @"RCD:TstMsg"

/*!
 Demo测试用的自定义消息类

 @discussion Demo测试用的自定义消息类，此消息会进行存储并计入未读消息数。
 */
@interface DepositMessage : RCMessageContent <NSCoding>

/*!
 测试消息的内容
 */
@property(nonatomic, strong) NSString *amotStr;

@property(nonatomic,strong) NSNumber* isPay;


/*!
 初始化测试消息

 @param content 文本内容
 @return        测试消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end