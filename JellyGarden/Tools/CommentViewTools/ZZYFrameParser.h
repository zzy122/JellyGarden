//
//  ZZYFrameParser.h
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZYCoreTextData.h"
#import "ZZYFramParserConfig.h"
@interface ZZYFrameParser : NSObject

+ (ZZYCoreTextData*)parseContent:(NSArray*)styleAry config:(ZZYFramParserConfig*)config;
@end
