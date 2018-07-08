//
//  CSIIGesturePasswordController.h
//  CSIIGesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CSIITentacleView.h"
#import "CSIIGesturePasswordView.h"
typedef void (^UnlockState) (BOOL success);
@class CSIIGesturePasswordController;


@protocol GesturePasswordControllerDelegte;

@interface CSIIGesturePasswordController : UIViewController
<ResetDelegate,CSIIGesturePasswordDelegate>


//第一次使用设置密码
@property(nonatomic,assign)BOOL isLunch;
@property (nonatomic,strong) CSIIGesturePasswordView * gesturePasswordView;

@property(nonatomic,weak)id<GesturePasswordControllerDelegte> delegate;
- (CSIIGesturePasswordController*)initwithType:(InitializeType)type withState:(UnlockState)state;//初始化

@end

@protocol GesturePasswordControllerDelegte <NSObject>
@optional

- (void)gesturePasswordController:(CSIIGesturePasswordController *)controller loginStatue:(BOOL)success;

//-(void)getserloginFinish;

-(void)loginTimeFinish;
@end





