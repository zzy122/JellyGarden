//
//  CSIITentacleView.h
//  CSIIGesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ResetDelegate <NSObject>
@optional
- (BOOL)resetPassword:(NSString *)result;

@end

//@protocol VerificationDelegate <NSObject>
//
//- (BOOL)verification:(NSString *)result;
//
//@end
//@protocol rerificationDelegate <NSObject>
//
//- (BOOL)verification:(NSString *)result;
//
//@end
@protocol TouchBeginDelegate <NSObject>

- (void)gestureTouchBegin;

@end



@interface CSIITentacleView : UIView

@property (nonatomic,strong) NSArray * buttonArray;

//@property (nonatomic,assign) id<VerificationDelegate> rerificationDelegate;

@property (nonatomic,assign) id<ResetDelegate> resetDelegate;

@property (nonatomic,assign) id<TouchBeginDelegate> touchBeginDelegate;

/*
 1: Verify  登录时用
 2: Reset
 */
//@property (nonatomic,assign) NSInteger style;

- (void)enterArgin;
- (void)errorManager;

@end
