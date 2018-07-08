//
//  CSIIGesturePasswordView.m
//  CSIIGesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "CSIIGesturePasswordView.h"
#import "CSIIGesturePasswordButton.h"
#import "CSIITentacleView.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MiniWidth 1.f /[UIScreen mainScreen].scale
@implementation CSIIGesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}

@synthesize forgetButton;
@synthesize changeButton;
@synthesize backButton;
@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame WithTitleStr:(NSString *)titlestr withType:(InitializeType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];

        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH - 60, SCREEN_WIDTH, SCREEN_WIDTH)];
        
        
        CGFloat iconWidth = 60;
        CGFloat betweenDistance = (CGRectGetWidth(view.frame) - iconWidth*3) / 4.0;
        
        
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            CSIIGesturePasswordButton * gesturePasswordButton = [[CSIIGesturePasswordButton alloc]initWithFrame:CGRectMake(betweenDistance + col * (betweenDistance + iconWidth), betweenDistance + row * (betweenDistance + iconWidth), iconWidth, iconWidth)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        
        
        [self addSubview:view];
        tentacleView = [[CSIITentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        state = [[UILabel alloc] init];
        [state setTextAlignment:NSTextAlignmentCenter];
        state.backgroundColor = [UIColor clearColor];
        [state setFont:[UIFont systemFontOfSize:17.f]];
        state.frame = CGRectMake(0, CGRectGetMinY(view.frame), CGRectGetWidth(self.frame), 30);
        [self addSubview:state];

        
        state.text = titlestr;
        [state setTextColor:[UIColor grayColor]];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(frame), CGRectGetMaxY(view.frame), MiniWidth, 30)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        forgetButton = [[UIButton alloc]init];
        
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetButton setTitle:@"密码登录" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(accountPasswordLogin) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        
        forgetButton.frame = CGRectMake(CGRectGetMinX(lineView.frame) - 100, CGRectGetMidY(lineView.frame) - 15, 100, 30);
        
        
        changeButton = [[UIButton alloc]init];
        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeButton setTitle:@"切换账号" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
        changeButton.frame = CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMinY(forgetButton.frame), 120, 30);
        [self addSubview:changeButton];
       
//        self.indecator  = [[LLLockIndicator alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) / 2.0 - 30, CGRectGetMinY(state.frame) - 90, 60, 60)];
//        [self addSubview:self.indecator];
        
        self.logoimgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame) / 2.0 - 35, CGRectGetMinY(state.frame) - 90, 70, 70)];
        self.logoimgView.layer.cornerRadius = 35;
        self.logoimgView.clipsToBounds = true;
        
        
        
        self.bankNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoimgView.frame), CGRectGetWidth(frame), 30)];
        self.bankNameLab.textColor = [UIColor whiteColor];
        self.bankNameLab.text = @"";
        self.bankNameLab.textAlignment = NSTextAlignmentCenter;
        self.bankNameLab.font = [UIFont systemFontOfSize:21];
        self.bankNameLab.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bankNameLab];
        [self addSubview:self.logoimgView];
        switch (type) {
            case InitializeTypeLogin:
//                self.indecator.hidden = YES;
                break;
            case InitializeTypeReset:
//                self.indecator.hidden = YES;
                changeButton.hidden = YES;
                lineView.hidden = YES;
                forgetButton.hidden = YES;
                break;
            case InitializeTypeSet:
                lineView.hidden = YES;
                changeButton.hidden = YES;
                forgetButton.hidden = YES;
                self.bankNameLab.hidden = YES;
                break;
            case InitializeTypeClose:
//                self.indecator.hidden = YES;
                changeButton.hidden = YES;
                lineView.hidden = YES;
                forgetButton.hidden = YES;
                break;
                
            default:
                break;
        }
        
        
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
       
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{

}

- (void)gestureTouchBegin {
//    [self.state setText:@""];
}

- (void)accountPasswordLogin{
    if (self.gesturePasswordDelegate && [self.gesturePasswordDelegate respondsToSelector:@selector(accountPasswordLogin:)]) {
        [gesturePasswordDelegate accountPasswordLogin:ChangeTypeAccountPasswordLogin];
    }
    
}

- (void)change{
    [gesturePasswordDelegate change];
}
- (void)back{
    [gesturePasswordDelegate back];
}

@end
