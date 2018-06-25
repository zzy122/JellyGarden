//
//  ReadDestroryView.h
//  JellyGarden
//
//  Created by zzy on 2018/6/25.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadDestroyMessage.h"
@interface ReadDestroryView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UIImageView *tagImagV;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *TapLab;
@property(nonatomic,assign)CGRect tagRect;
@property(nonatomic,strong)ReadDestroyMessage* mess;
+ (ReadDestroryView*)getReadDestroryView;
@end
