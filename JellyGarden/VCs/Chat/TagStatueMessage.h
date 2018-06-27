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

//@property(nonatomic,strong)NSString* amountStr;
+ (instancetype)messageWithContent:(NSString *)content;
@end
