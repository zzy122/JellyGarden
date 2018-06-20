//
//  datepicker.m
//  test
//
//  Created by zzy on 16/7/13.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import "ZZYdatepicker.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ZZYdatepicker()
@property(nonatomic,strong)UIDatePicker* datePicker;
@property(nonatomic,strong)NSString* datestr;

@property(nonatomic,strong)UIPickerView * picker;
@property(nonatomic,strong) UIButton* finish;
@property (nonatomic, strong) UILabel *dateLab;

@property(nonatomic,strong)NSString* selectStr;

@property(nonatomic,strong)UIView* keyWindow;

@property(nonatomic,strong)UIView * backView;

@property(nonatomic,strong)UIView* btnBackView;

@property(nonatomic,strong)UIView * pikerBackView;
@end
@implementation ZZYdatepicker

- (UIView *)backView
{
    if (!_backView) {
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.alpha = 0.3;
        _backView.backgroundColor = [UIColor grayColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenPickerView)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 256);
        
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        
        // 完成按钮背景
        self.btnBackView = [[UIView alloc]init];
        self.btnBackView.backgroundColor = [UIColor colorWithRed:84.0 / 255.0 green:131.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
        [self addSubview:self.btnBackView];
        self.btnBackView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 40);

        
        // 完成按钮
        self.finish = [[UIButton alloc]init];
        [self.finish addTarget:self action:@selector(clickfinish) forControlEvents:UIControlEventTouchUpInside];
        [self.finish.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.finish setTitle:@"完成" forState:UIControlStateNormal];
        [self.finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnBackView addSubview:self.finish];
        self.finish.frame = CGRectMake(CGRectGetWidth(self.btnBackView.frame) - 50, 0, 40, 40);
       
        
        self.dateLab = [[UILabel alloc] init];
        self.dateLab.textColor = [UIColor whiteColor];
        [self addSubview:self.dateLab];
        self.dateLab.frame = CGRectMake(8, 5, CGRectGetMinX(self.finish.frame) - 16, 30);
        
//        [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(8);
//            make.centerY.mas_equalTo(self.btnBackView.mas_centerY);
//            make.right.mas_equalTo(self.finish.mas_left).mas_equalTo(-8);
//        }];
        
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        if (self.dateStr.length != 0) {
            [self setDate];
        }
//        self.datePicker.minimumDate = [NSDate date];
        //        self.datePicker.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80, 80);
        [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        [self.datePicker setCalendar:[NSCalendar currentCalendar]];
        [self.datePicker addTarget:self action:@selector(clicldatepick:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.datePicker];
        self.datePicker.frame = CGRectMake(0, CGRectGetHeight(self.btnBackView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(self.btnBackView.frame));
//        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.finish.mas_bottom).mas_equalTo(0);
//            make.left.right.bottom.mas_equalTo(0);
//        }];
        
        NSDateFormatter *forTime=[[NSDateFormatter alloc]init];
        [forTime setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateTime = [forTime stringFromDate:[NSDate date]];
        [forTime setDateFormat:@"eeee"];
        NSString *day = [forTime stringFromDate:[NSDate date]];
        self.dateLab.text = [NSString stringWithFormat:@"%@  %@", dateTime, day];
    }
    return self;
}

- (void)setDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:self.dateStr];
    [self.datePicker setDate:date animated:YES];
}

- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    self.datestr = _dateStr;
    if (self.datePicker) {
        [self setDate];
    }
}
- (void)showPickerView {
    [self.keyWindow addSubview:self.backView];
    [self.keyWindow addSubview:self];
    
    [UIView animateWithDuration:0 animations:^{
        CGRect frame = self.backView.frame;
        frame.origin.y = 0;
        self.backView.frame = frame;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = SCREEN_HEIGHT - 256;
        self.frame = frame;
    }];
}
- (void)hidenPickerView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = SCREEN_HEIGHT;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)clickfinish
{
    if (self.datestr.length>0) {
       self.back(self.datestr);
    }
    else if (self.dateStr.length > 0)
    {
        self.back(self.dateStr);
    }
    else
    {
        [self hidenPickerView];
    }
    
}
- (void)clicldatepick:(UIDatePicker*)picker
{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* datestr = [format stringFromDate:picker.date];
    NSLog(@"改变:%@",datestr);
    
    NSDateFormatter *forTime=[[NSDateFormatter alloc]init];
    [forTime setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateTime = [forTime stringFromDate:picker.date];
    [forTime setDateFormat:@"eee"];
    NSString *day = [forTime stringFromDate:picker.date];
    
    self.dateLab.text = [NSString stringWithFormat:@"%@  %@", dateTime, day];
    
    self.datestr = datestr;
}



@end
