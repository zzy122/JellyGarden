//
//  WCLRecordVideoVC.h
//  JellyGarden
//
//  Created by zzy on 2018/6/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCLRecordVideoVC : UIViewController
- (void)recordVideoResult:(void (^) (NSString*))path;
@end
