//
//  ZZYLinkTextData.h
//  test
//
//  Created by zzy on 2018/5/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^clickText) (void);
@interface ZZYLinkTextData : NSObject

@property(nonatomic,weak)clickText clickTag;
@property(nonatomic,assign)NSRange rang;
@end
