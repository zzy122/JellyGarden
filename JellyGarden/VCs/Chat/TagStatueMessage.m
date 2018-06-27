//
//  TagStatueMessage.m
//  JellyGarden
//
//  Created by zzy on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "TagStatueMessage.h"

@implementation TagStatueMessage
///初始化
+ (instancetype)messageWithContent:(NSString *)content {
    TagStatueMessage *text = [[TagStatueMessage alloc] init];
//    text.amountStr = content;
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
//        self.amountStr = [aDecoder decodeObjectForKey:@"amountStr"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.amountStr forKey:@"amountStr"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:self.amountStr forKey:@"amountStr"];
    
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
//            self.amountStr = dictionary[@"amountStr"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
            
        }
    }
}

///// 会话列表中显示的摘要
- (NSString *)conversationDigest {

    if ([self.senderUserInfo.name isEqualToString:[RCIM sharedRCIM].currentUserInfo.name]) {
        return [NSString stringWithFormat:@"你支付了%@发起的定金",self.senderUserInfo.name];
    }
    else
    {
       return  [NSString stringWithFormat:@"%@支付了你发起的定金",self.senderUserInfo.name];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
