//
//  ReadDestroyMessage.m
//  JellyGarden
//
//  Created by zzy on 2018/6/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ReadDestroyMessage.h"

@implementation ReadDestroyMessage

+ (instancetype)messageWithContent:(NSString *)content {
    ReadDestroyMessage *text = [[ReadDestroyMessage alloc] init];
//    if (text) {
//        text.amotStr = content;
//    }
    
    return text;
}

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
//        self.amotStr = [aDecoder decodeObjectForKey:@"amotStr"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.amotStr forKey:@"amotStr"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:self.amotStr forKey:@"amotStr"];
//    [dataDict setObject:self.isPay forKey:@"isPay"];
//
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (dictionary) {
//            self.amotStr = dictionary[@"amotStr"];
//            self.isPay = dictionary[@"isPay"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
//    return self.amotStr;
    return @"";
}

///消息的类型名
+ (NSString *)getObjectName {
//    return RCDTestMessageTypeIdentifier;
    return @"";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
