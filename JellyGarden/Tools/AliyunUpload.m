//
//  AliyunManager.m
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "AliyunUpload.h"
NSString * const AliyunAccessKey = @"qkREjtYFlBHTTwxD";
NSString * const AliyunSecretKey = @"VoMOWGTfejU1iaM05vEfpOw1WWwpae";
NSString * const endPoint = @"oss-cn-beijing.aliyuncs.com";
NSString * const SERVER_HOST = @"http://39.105.9.66/mask/app/api/";
NSString * const BucketName = @"jellyGarden";
#import "JellyGarden-Swift.h"
@interface AliyunUpload()
@property(nonatomic,strong)OSSClient* client;
@end

@implementation AliyunUpload
+(AliyunUpload *)share
{
    
    static AliyunUpload* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AliyunUpload new];
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
    __block int failedCount = 0;
    __block int succecCount = 0;
    for (AliyunUploadModel *model in images) {
        if (model) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = BucketName;
               
                put.objectKey = model.fileName;
                put.contentType = @"application/x-png";
                
                
                //上传date
                NSData *data = UIImageJPEGRepresentation(model.image, 0.3);
                put.uploadingData = data;
                // 阻塞直到上传完成
                OSSTask * putTask = [self.client putObject:put];
                [putTask waitUntilFinished];
                if (!putTask.error) {
                    NSString* urlPath = [NSString stringWithFormat:@"http://jellygarden.oss-cn-beijing.aliyuncs.com/%@",model.fileName];
                    //添加到数组回传
                    [callBackNames addObject:urlPath];
                    succecCount++;
                    NSLog(@"upload object success!");
                } else {
                    failedCount++;
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                if (isAsync) {
                    if (model == images.lastObject) {
                        NSLog(@"upload object finished!");
                        if (cpmpletion) {
                            if (succecCount == 0) {
                                cpmpletion([NSArray arrayWithArray:callBackNames],succecCount,failedCount,UploadImageFailed);
                                return ;
                            }
                            cpmpletion([NSArray arrayWithArray:callBackNames],succecCount,failedCount,UploadImageSuccess);
                        }
                        return ;
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
            cpmpletion([NSArray arrayWithArray:callBackNames],succecCount,failedCount, UploadImageSuccess);
            
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
- (void)upLoadVedioToAliyun:(NSString *)VedioPath name:(NSString*)vedioName complection:(VedioBack)complection
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = BucketName;
    
    put.objectKey = vedioName;
    
    put.uploadingFileURL = [NSURL fileURLWithPath:VedioPath];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"application/octet-stream";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [self.client putObject:put];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [putTask waitUntilFinished]; // 阻塞直到上传完成
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!putTask.error) {
                if (complection) {
                    NSString* resultUrl = [NSString stringWithFormat:@"http://jellygarden.oss-cn-beijing.aliyuncs.com/%@",vedioName];
                    complection(resultUrl,UploadImageSuccess);
                }
                //   NSLog(@"upload object success!");
            } else {
                if (complection) {
                    NSString* resultUrl = [NSString stringWithFormat:@"http://jellygarden.oss-cn-beijing.aliyuncs.com/%@",vedioName];
                    complection(resultUrl,UploadImageFailed);
                }
                // NSLog(@"upload object failed, error: %@" , putTask.error);
            }
            
            
            
        });
        
    });
}
//- (void)test{
////    [self.view addSubview:self.videoHud];
////    [SingleManager shareManager].isResumableUpload = YES;
//    //阿里云视频上传的方法
//    __block NSString * recordKey;
//    NSURL *filePath = [NSURL URLWithString:@""];
//    NSString * bucketName = BucketName;
////    NSString * objectKey;
//    [[[[OSSTask taskWithResult:nil] continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
//        
//    }] continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
//        
//    }] continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
//        
//    }] ;
//    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
//        // 为该文件构造一个唯一的记录键
//        //        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
//        NSDate * lastModified;
//        NSError * error;
//        [filePath getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
//        if (error) {
//            return [OSSTask taskWithError:error];
//        }
//        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:[filePath absoluteString]], lastModified];
//        NSLog(@"recordKeyrecordKeyrecordKey-------%@",recordKey);
//        // 通过记录键查看本地是否保存有未完成的UploadId
//        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//        
//        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
//    }]
//        continueWithSuccessBlock:^id(OSSTask *task) {
//            if (!task.result) {
//                // 如果本地尚无记录，调用初始化UploadId接口获取
//                OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
//                initMultipart.bucketName = bucketName;
//                initMultipart.objectKey = objectKey;
//                initMultipart.contentType = @"application/octet-stream";
//                return [self.client multipartUploadInit:initMultipart];
//            }
//            OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
//            return task;
//        }]
//       continueWithSuccessBlock:^id(OSSTask *task) {
//           NSString * uploadId = nil;
//           
//           if (task.error) {
//               return task;
//           }
//           if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
//               uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
//           } else {
//               uploadId = task.result;
//           }
//           
//           if (!uploadId) {
//               return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
//                                                                 code:OSSClientErrorCodeNilUploadid
//                                                             userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
//           }
//           // 将“记录键：UploadId”持久化到本地存储
//           NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//           [userDefault setObject:uploadId forKey:recordKey];
//           [userDefault synchronize];
//           return [OSSTask taskWithResult:uploadId];
//       }]
//      continueWithSuccessBlock:^id(OSSTask *task) {
//          // 持有UploadId上传文件
//          OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
//          resumableUpload.bucketName = bucketName;
//          resumableUpload.objectKey = objectKey;
//          resumableUpload.uploadId = task.result;
//          resumableUpload.uploadingFileURL = filePath;
//          resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//              float number = (float)totalBytesSent/(float)totalBytesExpectedToSend;
////              self.videoHud.progress = number;
//          };
//          return [self.client resumableUpload:resumableUpload];
//      }]
//     continueWithBlock:^id(OSSTask *task) {
//         if (task.error) {
//             if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
//                 // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
//                 [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
//             }
//         } else {
//             dispatch_async(dispatch_get_main_queue(), ^{
////                 [self.videoHud hide:YES];
////                 self.videoHud = nil;
//                 //删除沙盒下面对应的视频文件
//                 //                 NSFileManager *defauleManager = [NSFileManager defaultManager];
//                 //                 NSString *tempPath = [filePath absoluteString];
//                 //                 [defauleManager removeItemAtPath:tempPath error:nil];
//                 NSFileManager *fileManager = [NSFileManager defaultManager];
//                 NSArray *fileListArray = [fileManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] error:nil];
//                 for (NSString *file in fileListArray)
//                 {
//                     NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:file];
//                     NSString *extension = [path pathExtension];
//                     if ([extension compare:@"mp4" options:NSCaseInsensitiveSearch] == NSOrderedSame)
//                     {
//                         [fileManager removeItemAtPath:path error:nil];
//                     }
//                 }
//             });
//             NSLog(@"上传完成!");
//
//             [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
////             [self uploadVideoInfoWithObjectKey:objectKey duration:[NSString stringWithFormat:@"%f.1",VideoDuration]];
//         }
//         return nil;
//     }];
//}
@end
