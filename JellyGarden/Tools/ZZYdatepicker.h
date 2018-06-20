//
//  datepicker.h
//  test
//
//  Created by zzy on 16/7/13.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZYdatepicker : UIView
@property(nonatomic,copy) void (^back)(NSString* backstr);
//当前日期
@property(nonatomic,strong) NSString* dateStr;
-(void)showPickerView;
-(void)hidenPickerView;
@end
