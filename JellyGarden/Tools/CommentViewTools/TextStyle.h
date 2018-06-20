//
//  TextStyle.h
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface TextStyle : NSObject<YYModel>
@property(nonatomic,strong)NSString* content;//文字内容
@property(nonatomic,strong)NSString* color;//文字颜色
@property(nonatomic,assign)NSInteger size;//文字大小
@end
