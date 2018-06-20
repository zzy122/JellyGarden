//
//  AliyunManager.m
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "AliyunManager.h"
NSString * const AliyunAccessKey = @"qkREjtYFlBHTTwxD";
NSString * const AliyunSecretKey = @"VoMOWGTfejU1iaM05vEfpOw1WWwpae";
NSString * const endPoint = @"http://img-cn-hangzhou.aliyuncs.com";
NSString * const SERVER_HOST = @"http://39.105.9.66/mask/app/api/";

#import "JellyGarden-Swift.h"
@interface AliyunManager()
@property(nonatomic,strong)OSSClient* client;
@end

@implementation AliyunManager
+(AliyunManager *)share
{
    
    static AliyunManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AliyunManager new];
        [manager initOSSClient];
    });
    return  manager;
}
- (void)uploadImageToAliyun:(NSArray<AliyunUploadModel *> *)images  isAsync:(BOOL)isAsync completion:(back)cpmpletion
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (AliyunUploadModel *model in images) {
        if (model) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = @"jellyGarden";
                NSString* urlPath = [NSString stringWithFormat:@"http://jellygarden.oss-cn-beijing.aliyuncs.com/%@",model.fileName];
                put.objectKey = model.fileName;
                put.contentType = @"image/jpeg";
                //添加到数组回传
                [callBackNames addObject:urlPath];
                
                //上传date
                NSData *data = UIImageJPEGRepresentation(model.image, 0.3);
                put.uploadingData = data;
                // 阻塞直到上传完成
                OSSTask * putTask = [self.client putObject:put];
                [putTask waitUntilFinished];
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                if (isAsync) {
                    if (model == images.lastObject) {
                        NSLog(@"upload object finished!");
                        if (cpmpletion) {
                            cpmpletion([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        NSLog(@"haha");
        if (cpmpletion) {
            cpmpletion([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
            
        }
    }
}
- (void)initOSSClient {
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKey
                                                                                                            secretKey:AliyunSecretKey];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    self.client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
}
@end
