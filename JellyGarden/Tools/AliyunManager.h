//
//  AliyunManager.h
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AliyunUploadModel.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};
typedef void (^back) (NSArray<NSString *> *names, UploadImageState state);
@interface AliyunManager : NSObject
+ (AliyunManager*)share;

- (void)uploadImageToAliyun:(NSArray<AliyunUploadModel*> *)images isAsync:(BOOL)isAsync completion:(back) cpmpletion;

@end
