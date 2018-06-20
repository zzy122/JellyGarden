//
//  ZZYCoreTextData.h
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TextStyleModel.h"
#import "ImageStyle.h"
#import "ZZYLinkTextData.h"
@interface ZZYCoreTextData : NSObject
@property(nonatomic,assign)CTFrameRef ctFrame;
@property(nonatomic,strong)NSAttributedString* contentStr;

@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong)NSArray<ImageStyle *>* imageAry;

@property(nonatomic,strong)NSMutableArray<ZZYLinkTextData*>* rangeAry;

- (void)clickTextWithStr:(NSString*)str Click:(clickText)click;


@end
