//
//  CSIIGesturePasswordController.m
//  CSIIGesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "CSIIGesturePasswordController.h"
#define GESTERPASSWORD @"GesterPassword"

@interface CSIIGesturePasswordController ()<UIAlertViewDelegate,CSIIGesturePasswordDelegate>



@property(nonatomic,assign)NSInteger LogintCount;

@property(nonatomic,assign)NSInteger chance;

@property(nonatomic,assign)InitializeType initType;
@property(nonatomic,strong)NSString* previousString;
@property(nonatomic,copy)UnlockState myState;



@end

@implementation CSIIGesturePasswordController {
}

- (CSIIGesturePasswordController*)initwithType:(InitializeType)type withState:(UnlockState)state
{
    self.initType = type;
    self.myState = state;
    self.gesturePasswordView = [[CSIIGesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds WithTitleStr:@"请绘制新的开锁图案" withType:type];
     self.gesturePasswordView.gesturePasswordDelegate = self;
     self.gesturePasswordView.tentacleView.resetDelegate = self;
    switch (type) {
        case InitializeTypeLogin:
        {
            [ self.gesturePasswordView setGesturePasswordDelegate:self];
             self.gesturePasswordView.backButton.hidden = YES;
            self.gesturePasswordView.forgetButton.hidden = YES;
            self.gesturePasswordView.changeButton.hidden = YES;
            [self.gesturePasswordView.state setText:@"请绘制开锁图案"];
//             self.gesturePasswordView.indecator.hidden = YES;
        }
            break;
            
        case InitializeTypeClose:
        {
            [ self.gesturePasswordView.state setTextColor:[UIColor blackColor]];
            [ self.gesturePasswordView.state setText:@"请绘制开锁图案"];
             self.gesturePasswordView.forgetButton.hidden = YES;
             self.gesturePasswordView.changeButton.hidden = YES;
        }
            break;
        case InitializeTypeReset:
        {
//             self.gesturePasswordView.indecator.hidden = YES;
             self.gesturePasswordView.changeButton.hidden = YES;
            [ self.gesturePasswordView.state setText:@"请绘制开锁图案"];
        }
            break;
        case InitializeTypeSet:
        {
             self.gesturePasswordView.changeButton.hidden = YES;
             self.gesturePasswordView.forgetButton.hidden = YES;
//             self.gesturePasswordView.indecator.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    [self.view addSubview: self.gesturePasswordView];
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.LogintCount = 0;
    self.chance = 0;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 判断是否已存在手势密码
//- (BOOL)exist{
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:GESTERPASSWORD].length > 0)return YES;
//    return NO;
//}

#pragma mark - 清空记录
//- (void)clear{
//
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:GESTERPASSWORD];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GESTERISSET];
//
//}



#pragma mark - 改变手势密码
- (void)back{
  
    [self ClosePageAnimated:NO compleHander:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.initType == InitializeTypeLogin) {
        return;
    }
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 30,80, 30);
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [closeBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(ClosePage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:closeBtn];
    
}
- (void)ClosePage
{
    [self ClosePageAnimated:YES compleHander:nil];
}

- (void)ClosePageAnimated:(BOOL)animation compleHander:(void(^)(void))hander{

    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:animation];
        }
    }
    else{
        //present方式
        [self dismissViewControllerAnimated:animation completion:hander];
    }
}

- (BOOL)resetPassword:(NSString *)result{
    NSString* Mypassword = [[NSUserDefaults standardUserDefaults] objectForKey:GESTERPASSWORD];
    NSLog(@"执行了");
    if (self.initType == InitializeTypeClose) {//关闭手势
        
        if ([result isEqualToString:Mypassword]) {
            [self.gesturePasswordView.state setText:@"验证成功"];
            self.myState(YES);
            [self.navigationController popViewControllerAnimated:YES];
            return YES;
        }
        else
        {
            [self setGesterTitle:@"手势密码错误，请重新绘制" WithColoer:[UIColor redColor]];
            
            [self.gesturePasswordView.tentacleView performSelector:@selector(enterArgin) withObject:nil afterDelay:0.3];
            return NO;
        }
    }
    else if(self.initType == InitializeTypeReset) {//重置手势密码
         return [self resetPasswordWithLogin:result];
    }
    else if(self.initType == InitializeTypeSet)//设置手势密码
    {//第二次输入手势密码或者第一次设置手势密码
        if ([self.previousString isEqualToString:@""] || self.previousString == nil) {
            if(result.length<4)
            {
                self.previousString = @"";
                [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
                [self.gesturePasswordView.state setText:@"至少连接4个点，请重新绘制"];
                [self.gesturePasswordView.tentacleView performSelector:@selector(enterArgin) withObject:nil afterDelay:0.3];
                return NO;
            }
//            [self.gesturePasswordView.indecator setPasswordString:result];//九点指示图标
            self.previousString=result;
            [self.gesturePasswordView.tentacleView enterArgin];
            
            [self.gesturePasswordView.state setTextColor:[UIColor grayColor]];
            [self.gesturePasswordView.state setText:@"请再次绘制解锁图案"];

            return YES;
        }
        else {//保存手势密码
            if ([result isEqualToString:self.previousString]) {
                [self SavePasswordStr:result];
                self.myState(YES);
                return YES;
            }
            else{
                [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
                [self.gesturePasswordView.state setText:@"两次绘制的解锁图案不一致"];
                
                [self.gesturePasswordView.tentacleView performSelector:@selector(enterArgin) withObject:nil afterDelay:0.3];
                return NO;
            }
        }
    }
    else if (self.initType == InitializeTypeLogin)
    {
        if(result.length<4)
        {
            [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
            [self.gesturePasswordView.state setText:@"至少连接4个点，请重新绘制"];
            [self.gesturePasswordView.tentacleView performSelector:@selector(enterArgin) withObject:nil afterDelay:0.3];
            return NO;
        }
        else
        {
            if ([Mypassword isEqualToString:result]) {
                self.myState(YES);
                [self dissMyVC];
                return YES;
            }
            else
            {
               [self setGesterTitle:@"解锁图案错误，请重新绘制" WithColoer:[UIColor redColor]];
            }
            
            
        }
        
    }
    return YES;
    
}
- (BOOL)resetPasswordWithLogin:(NSString *)gestureCode{
    
    if (gestureCode.length < 4) {
        [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
        [self.gesturePasswordView.state setText:@"至少连接4个点，请重新绘制"];
        [self.gesturePasswordView.tentacleView performSelector:@selector(enterArgin) withObject:nil afterDelay:0.3];
        return NO;
    }
   
    NSString* Mypassword = [[NSUserDefaults standardUserDefaults] objectForKey:GESTERPASSWORD];
    if ([gestureCode isEqualToString:Mypassword]) {
        [self setGesterTitle:@"请绘制新密码" WithColoer:[UIColor whiteColor]];
//        self.gesturePasswordView.indecator.hidden = NO;
        self.initType = InitializeTypeSet;
        self.gesturePasswordView.forgetButton.hidden = YES;
        return YES;
    }
    else
    {
        [self.gesturePasswordView.tentacleView enterArgin];
        [self.gesturePasswordView.state setTextColor:[UIColor redColor]];
        [self.gesturePasswordView.state setText:@"原密码错误"];
        [self.gesturePasswordView.tentacleView errorManager];
        return NO;
    }
   
}


- (void)setGesterTitle:(NSString*)title WithColoer:(UIColor*)color
{
    [self.gesturePasswordView.tentacleView enterArgin];
    [self.gesturePasswordView.state setTextColor:color];
    [self.gesturePasswordView.state setText:title];
//    self.gesturePasswordView.indecator.hidden = YES;

}
- (void)SavePasswordStr:(NSString*)PassCode
{

    
    [[NSUserDefaults standardUserDefaults] setObject:PassCode forKey:GESTERPASSWORD];
    
   

    [self.gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
    [self.gesturePasswordView.state setText:@"已保存手势密码"];
//    self.gesturePasswordView.indecator.hidden = YES;
    [self dissMyVC];
   
}
- (void)dissMyVC
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
//    if (self.isLunch) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [self.navigationController popViewControllerAnimated:NO];
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
