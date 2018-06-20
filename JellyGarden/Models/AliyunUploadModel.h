//
//  AliyunUploadModel.h
//  JellyGarden
//
//  Created by zzy on 2018/6/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AliyunUploadModel : NSObject
@property(nonatomic,strong)UIImage* image;
@property(nonatomic,strong)NSString* fileName;//要有后缀名 如.jpg
@end
