//
//  WCLRecordVideoVC.m
//  JellyGarden
//
//  Created by zzy on 2018/6/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import "WCLRecordVideoVC.h"
#import "WCLRecordEngine.h"
#import "WCLRecordProgressView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
typedef void (^ pathStr) (NSString* path);
typedef NS_ENUM(NSUInteger, UploadVieoStyle) {
    VideoRecord = 0,
    VideoLocation,
};

@interface WCLRecordVideoVC ()<WCLRecordEngineDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *recordBt;
@property (weak, nonatomic) IBOutlet UIButton *locationVideoBT;
@property (weak, nonatomic) IBOutlet WCLRecordProgressView *progressView;
@property (strong, nonatomic) WCLRecordEngine         *recordEngine;
@property (assign, nonatomic) BOOL                    allowRecord;//允许录制
@property (assign, nonatomic) UploadVieoStyle         videoStyle;//视频的类型
@property (strong, nonatomic) UIImagePickerController *moviePicker;//视频选择器
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;
@property(nonatomic,copy)pathStr vidiePath;
@end

@implementation WCLRecordVideoVC

- (void)dealloc {
    _recordEngine = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:[_playerVC moviePlayer]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.recordEngine startUp];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recordEngine shutdown];
}
- (void)recordVideoResult:(void (^)(NSString *))path
{
    self.vidiePath = path;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    }
    //前置摄像
    [self.recordEngine closeFlashLight];
    [self.recordEngine changeCameraInputDeviceisFront:YES];
    [self.recordEngine startUp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationVideoBT.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    // 博客地址：http://blog.csdn.net/wang631106979/article/details/51498009
    self.allowRecord = YES;
    self.titleLable.text = @"锄禾日当午,汗滴禾下锄";
    
    
}

//根据状态调整view的展示情况
- (void)adjustViewFrame {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.recordBt.selected) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }
        if (self.videoStyle == VideoRecord) {
            self.locationVideoBT.alpha = 0;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - set、get方法
- (WCLRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[WCLRecordEngine alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

- (UIImagePickerController *)moviePicker {
    if (_moviePicker == nil) {
        _moviePicker = [[UIImagePickerController alloc] init];
        _moviePicker.delegate = self;
        _moviePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _moviePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    }
    return _moviePicker;
}

#pragma mark - Apple相册选择代理
//选择了某个照片的回调函数/代理回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        //获取视频的名称
        NSString * videoPath=[NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerMediaURL]];
        NSRange range =[videoPath rangeOfString:@"trim."];//匹配得到的下标
        NSString *content=[videoPath substringFromIndex:range.location+5];
        //视频的后缀
        NSRange rangeSuffix=[content rangeOfString:@"."];
        NSString * suffixName=[content substringFromIndex:rangeSuffix.location+1];
        //如果视频是mov格式的则转为MP4的
        if ([suffixName isEqualToString:@"MOV"]) {
            NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
            __weak typeof(self) weakSelf = self;
            [self.recordEngine changeMovToMp4:videoUrl dataBlock:^(UIImage *movieImage) {
                
                [weakSelf.moviePicker dismissViewControllerAnimated:YES completion:^{
                    weakSelf.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:weakSelf.recordEngine.videoPath]];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[weakSelf.playerVC moviePlayer]];
                    [[weakSelf.playerVC moviePlayer] prepareToPlay];
                    
                    [weakSelf presentMoviePlayerViewControllerAnimated:weakSelf.playerVC];
                    [[weakSelf.playerVC moviePlayer] play];
                }];
            }];
        }
    }
}

#pragma mark - WCLRecordEngineDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self recordAction:self.recordBt];
        self.allowRecord = NO;
    }
    self.progressView.progress = progress;
}

#pragma mark - 各种点击事件
//返回点击事件
- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    self.vidiePath(self.recordEngine.videoPath);
}

//开关闪光灯
//- (IBAction)flashLightAction:(id)sender {
//    if (self.changeCameraBT.selected == NO) {
//        self.flashLightBT.selected = !self.flashLightBT.selected;
//        if (self.flashLightBT.selected == YES) {
//            [self.recordEngine openFlashLight];
//        }else {
//            [self.recordEngine closeFlashLight];
//        }
//    }
//}

//切换前后摄像头
//- (IBAction)changeCameraAction:(id)sender {
//    self.changeCameraBT.selected = !self.changeCameraBT.selected;
//    if (self.changeCameraBT.selected == YES) {
//        //前置摄像头
//        [self.recordEngine closeFlashLight];
//        self.flashLightBT.selected = NO;
//        [self.recordEngine changeCameraInputDeviceisFront:YES];
//    }else {
//        [self.recordEngine changeCameraInputDeviceisFront:NO];
//    }
//}

//录制下一步点击事件
//- (IBAction)recordNextAction:(id)sender {
//    if (_recordEngine.videoPath.length > 0) {
//        __weak typeof(self) weakSelf = self;
//        [self.recordEngine stopCaptureHandler:^(UIImage *movieImage) {
//            weakSelf.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:weakSelf.recordEngine.videoPath]];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[weakSelf.playerVC moviePlayer]];
//            [[weakSelf.playerVC moviePlayer] prepareToPlay];
//
//            [weakSelf presentMoviePlayerViewControllerAnimated:weakSelf.playerVC];
//            [[weakSelf.playerVC moviePlayer] play];
//        }];
//    }else {
//        NSLog(@"请先录制视频~");
//    }
//}

////当点击Done按键或者播放完毕时调用此函数
- (void) playVideoFinished:(NSNotification *)theNotification {
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self.playerVC dismissMoviePlayerViewControllerAnimated];
    self.playerVC = nil;
}

//本地视频点击视频
- (IBAction)locationVideoAction:(id)sender {
    self.videoStyle = VideoLocation;
    [self.recordEngine shutdown];
    [self presentViewController:self.moviePicker animated:YES completion:nil];
}

//开始和暂停录制事件
- (IBAction)recordAction:(UIButton *)sender {
    if (self.allowRecord) {
        self.videoStyle = VideoRecord;
        self.recordBt.selected = !self.recordBt.selected;
        if (self.recordBt.selected) {
            if (self.recordEngine.isCapturing) {
                [self.recordEngine resumeCapture];
            }else {
                [self.recordEngine startCapture];
            }
        }else {
            [self.recordEngine pauseCapture];
        }
        [self adjustViewFrame];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
