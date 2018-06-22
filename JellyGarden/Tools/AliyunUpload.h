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
    UploadImageSuccess  = 1,
    UploadImageContinue = 2
};
typedef void (^back) (NSArray<NSString *> *names,NSInteger successCount,NSInteger failedCount, UploadImageState state);
typedef void (^VedioBack) (NSString* vedioStr, UploadImageState state);
@interface AliyunUpload : NSObject
+ (AliyunUpload*)share;

- (void)uploadImageToAliyun:(NSArray<AliyunUploadModel*> *)images isAsync:(BOOL)isAsync completion:(back) cpmpletion;
- (void)upLoadVedioToAliyun:(NSString*)VedioPath name:(NSString*)vedioName complection:(VedioBack)complection;
@end
