//
//  ReadDestroyMessage.h
//  JellyGarden
//
//  Created by zzy on 2018/6/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
@interface ReadDestroyMessage : RCMessageContent
@property(nonatomic,strong) NSNumber* isRead; //是否已读照片 0 未读 1已读
@end
