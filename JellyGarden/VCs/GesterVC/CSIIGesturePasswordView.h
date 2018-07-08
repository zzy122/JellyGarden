//
//  CSIIGesturePasswordView.h
//  CSIIGesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CSIITentacleView.h"
#import "LLLockIndicator.h"

typedef NS_ENUM(NSUInteger, ChangeType) {
    ChangeTypeForgetGues,//忘记手势
    ChangeTypeResetGuesError,//重置判断五次
    ChangeTypeLoginError,//登录五次
    ChangeTypeAccountPasswordLogin,//密码登录
};
typedef NS_ENUM(NSInteger, InitializeType) {
    InitializeTypeLogin,//登录
    InitializeTypeReset,//重置
    InitializeTypeClose,//关闭
    InitializeTypeSet,//设置
    
};
@protocol CSIIGesturePasswordDelegate <NSObject>
@optional
- (void)accountPasswordLogin:(ChangeType)type;
- (void)change;
- (void)back;

@end

@interface CSIIGesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic,strong) CSIITentacleView * tentacleView;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,assign) id<CSIIGesturePasswordDelegate> gesturePasswordDelegate;
-(instancetype)initWithFrame:(CGRect)frame WithTitleStr:(NSString*)titlestr withType:(InitializeType)type;
@property (nonatomic,strong) UIImageView * logoimgView;//登录时的logo
@property (nonatomic,strong) UILabel* bankNameLab;


@property (nonatomic,strong) UIButton * forgetButton;
@property (nonatomic,strong) UIButton * changeButton;
@property (nonatomic,strong) UIButton * backButton;

//@property (nonatomic,strong) LLLockIndicator *indecator; // 九点指示图


@end
