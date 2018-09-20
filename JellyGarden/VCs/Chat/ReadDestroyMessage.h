//
//  ReadDestroyMessage.h
//  JellyGarden
//
//  Created by zzy on 2018/6/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#define RCDestroyImageMessageTypeIdentifier @"RC:destroyImage"
@interface ReadDestroyMessage : RCMessageContent <NSCoding>

@property(nonatomic,strong) NSString* imageUrl;
@end
