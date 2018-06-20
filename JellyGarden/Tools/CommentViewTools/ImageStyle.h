//
//  ImageStyle.h
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYModel/YYModel.h>
@interface ImageStyle : NSObject<YYModel>
@property(nonatomic,assign)CGFloat width;//图片宽
@property(nonatomic,assign)CGFloat height;//图片高
@property(nonatomic,strong)NSString* name;//图片名字
@property(nonatomic,assign)NSInteger position;//图片位置
@property(nonatomic,assign)CGRect imagePosition;
@end
