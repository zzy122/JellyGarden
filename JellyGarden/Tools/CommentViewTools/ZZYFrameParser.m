//
//  ZZYFrameParser.m
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ZZYFrameParser.h"
#import "TextStyleModel.h"
#import "TextStyle.h"
static CGFloat ascentCallback(void * ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback(void* ref){
    return 0.0;
};
static CGFloat widthCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
};

@implementation ZZYFrameParser

+ (ZZYCoreTextData *)parseContent:(NSArray *)styleAry config:(ZZYFramParserConfig *)config
{
    
    NSMutableArray* imageAry = [NSMutableArray new];
    NSMutableAttributedString* resultAry = [[NSMutableAttributedString alloc]init];
    if (styleAry.count > 0) {
        [styleAry enumerateObjectsUsingBlock:^(NSDictionary  * dic, NSUInteger idx, BOOL * _Nonnull stop) {
            TextStyleModel* model = [TextStyleModel yy_modelWithDictionary:dic];
            
            NSAttributedString* aStr = nil;
            if ([model.type isEqualToString: @"text"]) {
                TextStyle* style = [TextStyle yy_modelWithDictionary:dic];
                aStr = [self parseAttributeContentFromModel:style config:config];
            }
            else if ([model.type isEqualToString:@"img"])
            {
                ImageStyle* style = [ImageStyle yy_modelWithDictionary:dic];
                style.position = resultAry.length;
                [imageAry addObject:style];
                aStr = [self parseAttributeImageFromModel:dic config:config];
            }
//            else if ([model.type isEqualToString:@"link"])
//            {
//                TextStyle* style = [TextStyle yy_modelWithDictionary:dic];
//                aStr = [self parseAttributeContentFromModel:style config:config];
//                NSInteger loction = resultAry.length;
//                [resultAry appendAttributedString:aStr];
//
//                NSInteger lenth = resultAry.length - loction;
//                NSRange range = NSMakeRange(loction, lenth);
//            }
            [resultAry appendAttributedString:aStr];
        }];
        ZZYCoreTextData *data = [self parseAttributeContent:resultAry config:config];
        data.imageAry = [imageAry copy];
        return data;
    }
    else
    {
        return nil;
    }
}


+ (ZZYCoreTextData*)parseAttributeContent:(NSAttributedString*)content config:(ZZYFramParserConfig*)config
{
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //获得高度
    
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    ZZYCoreTextData* data = [ZZYCoreTextData new];
    data.contentStr = content;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    //将生成的CTFrameRef实例和计算好的高度保存到ZZYCoreTextData实例中
    //最后返回ZZYCoreTextData实例
    data.ctFrame = frame;
    data.height = textHeight;
    
//    CFRelease(frame);
    CFRelease(framesetter);
    return data;
    
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(ZZYFramParserConfig*)config height:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

//根据字符串返回字体信息
+ (NSAttributedString*)parseAttributeContentFromModel:(TextStyle*)model config:(ZZYFramParserConfig*)
config
{
    NSMutableDictionary* dict = [self attributeWithConfig:config];
    UIColor *color = [self colorFromTemPlate:model.color];
    dict[(id)kCTForegroundColorAttributeName] = (__bridge id _Nullable)(color.CGColor);
    CGFloat fontSize = model.size;
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        dict[(id)kCTFontAttributeName] = (__bridge id _Nullable)fontRef;
        CFRelease(fontRef);
    }
    
    return [[NSMutableAttributedString alloc]initWithString:model.content attributes: dict];
    
}
//设置图片占位符
+ (NSAttributedString*)parseAttributeImageFromModel:(NSDictionary*)style config:(ZZYFramParserConfig*)config
{
    
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallback;
    callBacks.getDescent = descentCallback;
    callBacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void*)(style));
    UniChar objectChar = 0xFFFC;
    NSString* content = [NSString stringWithCharacters:&objectChar length:1];
    NSDictionary* attributs = [self attributeWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc]initWithString:content attributes:attributs];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    return space;
}
+ (NSMutableDictionary*)attributeWithConfig:(ZZYFramParserConfig*)config
{
//    CGFloat fontSize = config.fontSize;
//    CTFontRef fontref = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSetting[kNumberOfSetting] = {{kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat),&lineSpace},{kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpace},{kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpace}};
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(theSetting, kNumberOfSetting);
    
//    UIColor* color = config.textColor;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    dict[(id)kCTForegroundColorAttributeName] = (__bridge id _Nullable)(color.CGColor);
//    dict[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontref);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id _Nullable)(paragraphRef);
    CFRelease(paragraphRef);
//    CFRelease(fontref);
    return dict;
}
+ (UIColor*)colorFromTemPlate:(NSString*)name
{
    UIColor *color = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    if ([name isEqualToString:@"blue"]) {color = [UIColor blueColor];}
    else if ([name isEqualToString:@"red"]){color = [UIColor redColor];}
    else if ([name isEqualToString:@"black"]){color = [UIColor blackColor];}
    else if ([name isEqualToString:@"yellow"]){color = [UIColor yellowColor];}
    else if ([name isEqualToString:@"green"]){color = [UIColor greenColor];}
    else if ([name isEqualToString:@"gray"]){color = [UIColor grayColor];}
    else if ([name isEqualToString:@"white"]){color = [UIColor whiteColor];}
    else if ([name isEqualToString:@"lightGray"]){color = [UIColor lightGrayColor];}
    else if ([name isEqualToString:@"darkGray"]){color = [UIColor darkGrayColor];}
    else if ([name isEqualToString:@"cyan"]){color = [UIColor cyanColor];}
    else if ([name isEqualToString:@"magenta"]){color = [UIColor magentaColor];}
    else if ([name isEqualToString:@"orange"]){color = [UIColor orangeColor];}
    else if ([name isEqualToString:@"purple"]){color = [UIColor purpleColor];}
    else if ([name isEqualToString:@"brown"]){color = [UIColor brownColor];}
    else if ([name isEqualToString:@"clear"]){color = [UIColor clearColor];}
    return color;
    
}
@end
