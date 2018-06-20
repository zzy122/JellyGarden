//
//  ZZYCoreTextData.m
//  test
//
//  Created by zzy on 2018/5/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "ZZYCoreTextData.h"

@implementation ZZYCoreTextData

- (NSMutableArray<ZZYLinkTextData *> *)rangeAry
{
    if (!_rangeAry) {
        _rangeAry = [NSMutableArray new];
    }
    return _rangeAry;
}
- (void)setImageAry:(NSArray<ImageStyle *> *)imageAry
{
    _imageAry = imageAry;
    [self fillImagePosition];
}
- (void)fillImagePosition{
    if (self.imageAry.count == 0) {
        return;
    }
    NSArray* lines = (__bridge NSArray*)CTFrameGetLines(self.ctFrame);
    NSInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    NSInteger imageIndex = 0;
    ImageStyle* model = self.imageAry.firstObject;
    for (int i = 0; i < lineCount; i ++) {
        if (model == nil)
        {
            return;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray* runObjArray = (NSArray*)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary * runattributs = (NSDictionary*)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runattributs valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary*metadic = CTRunDelegateGetRefCon(delegate);
            if (![metadic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            CGRect runbuns;
            CGFloat ascent;
            CGFloat descent;
            runbuns.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runbuns.size.height = ascent + descent;
            CGFloat xoffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runbuns.origin.x = lineOrigins[i].x + xoffset;
            runbuns.origin.y = lineOrigins[i].y - descent;
            CGPathRef pathref = CTFrameGetPath(self.ctFrame);
            CGRect colrect = CGPathGetBoundingBox(pathref);
            CGRect delegatebounds= CGRectOffset(runbuns, colrect.origin.x, colrect.origin.y);
            model.imagePosition = delegatebounds;
            imageIndex++;
            if (imageIndex >= self.imageAry.count) {
                model = nil;
                break;
            }
            else
            {
                model = self.imageAry[imageIndex];
            }
        }
    }
}
- (void)clickTextWithStr:(NSString *)str Click:(clickText)click
{
    NSString * content = self.contentStr.string;
    NSRange range = [content rangeOfString:str];
    if (range.location != NSNotFound) {
        ZZYLinkTextData* link = [ZZYLinkTextData new];
        link.clickTag = click;
        link.rang = range;
        [self.rangeAry addObject:link];
    }
    else
    {return;}
    
}

@end
