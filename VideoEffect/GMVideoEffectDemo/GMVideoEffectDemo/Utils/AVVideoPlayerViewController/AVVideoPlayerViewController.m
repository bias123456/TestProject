//
//  AVVideoPlayerViewController.m
//  ActU
//
//  Created by Bias.Xie on 2018/1/4.
//  Copyright © 2018年 Juer. All rights reserved.
//

#import "AVVideoPlayerViewController.h"
#import "NSString+Utils.h"
#import "AVKit/AVKit.h"

@interface AVVideoPlayerViewController () <AVPlayerItemOutputPullDelegate>

@property (nonatomic,readwrite,assign) GMVideoPlayerStatus playerStatus;
@property (nonatomic,readwrite,assign) NSTimeInterval duration;
@property (nonatomic,readwrite,assign) NSTimeInterval currentPosition;
@property (nonatomic,readwrite,assign) NSTimeInterval loadedTimeRanges;

@property (nonatomic,readwrite,copy) NSString *videoUrl;
@property (nonatomic,readwrite,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,readwrite,strong) AVPlayerItem *playerItem;
@property (nonatomic,readwrite,strong) AVPlayer *player;
@property (nonatomic,readwrite,strong) AVPlayerLayer *playerLayer;

@property (nonatomic ,strong) id playbackTimeObserver;//播放过程中的时间监听器

@property (nonatomic ,strong) AVPlayerItemVideoOutput *videoOutput;

@end

@implementation AVVideoPlayerViewController


- (instancetype)init{
    self = [super init];
    if( self ){
        
    }
    return self;
}

- (void)dealloc{
    

    NSLog(@"---viewController[%@] with class %@ was dellocated",self, NSStringFromClass([self class]));

    
    [self closeVideo];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
   // [self closeVideo];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (GMVideoPlayerTimeControlState)controlstate{
    if( self.player.rate > FLT_EPSILON ){
        return GMVideoPlayerTimeControlStatePlaying;
    }
    return GMVideoPlayerTimeControlStatePause;
}

- (void)setVolume:(float)volume{
    self.player.volume = volume;
}

- (float)volume{
    return self.player.volume;
}

- (void)setMuted:(BOOL)muted{
    self.player.muted = muted;
}

- (BOOL)muted{
    return self.player.muted;
}

- (void)openVideoWithUrl:(NSString *)videoUrl{

    
    self.videoUrl = videoUrl;
    NSURL *videoURL = self.videoUrl.toUrl;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:videoURL];
    
    [self openWithPlayerItem:item];
}

- (void)openWithPlayerItem:(AVPlayerItem *)item{

    
    [self closeVideo];
    
    self.playerItem = item;
    
    
    NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey:
                                   [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
    self.videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings];
    [self.videoOutput setDelegate:self queue:dispatch_get_main_queue()];
    [self.playerItem addOutput:self.videoOutput];
    
    
    
    self.playerStatus = GMVideoPlayerStatusNotReady;
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.playerLayer];
    
    //
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];}

- (void)updatePlayerLayerRegion{
    self.playerLayer.frame = self.view.bounds;
}

//已经准备好可以播放，duration单位：秒
- (void)didChangeStatusToReadyPlay:(BOOL)isSuccess duration:(NSTimeInterval)duration message:(NSString *)message{
    
    
    if( isSuccess == YES ){
        self.playerStatus = GMVideoPlayerStatusReadyToPlay;
    }else{
        self.playerStatus = GMVideoPlayerStatusNotReady;
    }
    
    self.duration = duration;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerDelegate gmVideoPlayer:self didChangeStatusToReadyPlay:isSuccess duration:duration message:message];
    });
    
    //if( isSuccess == YES ){
    //self.stateButton.enabled = YES;
    //_totalTime = [self convertTime:totalSecond];// 转换成播放时间的字符串格式
    //    weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",@"00",_totalTime];
    
    // [self customVideoSlider:duration];// 自定义UISlider外观
    //return;
    //}
    //DLog(@"message=%@",message);
    
}

//更新当前播放的秒数
- (void)didPlayToPosition:(NSTimeInterval)currentPosition{
    //    [weakSelf.videoSlider setValue:currentSecond animated:YES];
    //    NSString *timeString = [self convertTime:currentSecond];
    //    weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,_totalTime];
    self.currentPosition = currentPosition;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerDelegate gmVideoPlayer:self didPlayToPosition:currentPosition];
    });
}

//已缓冲的视频长度变化
- (void)didLoadTimeRanges:(NSTimeInterval)loadedTimeRanges{
    //    CMTime duration = _playerItem.duration;
    //    CGFloat totalDuration = CMTimeGetSeconds(duration);
    //    [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    
    self.loadedTimeRanges = loadedTimeRanges;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerDelegate gmVideoPlayer:self didLoadTimeRanges:loadedTimeRanges];
    });
}

//播放结束
- (void)didPlayEnd{
    //    __weak typeof(self) weakSelf = self;
    //    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
    //        [weakSelf.videoSlider setValue:0.0 animated:YES];
    //        [weakSelf.stateButton setTitle:@"Play" forState:UIControlStateNormal];
    //    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerDelegate gmVideoPlayerDidPlayEnd:self];
    });
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        
        [weakSelf didPlayToPosition:currentSecond];
    }];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = CMTimeGetSeconds(duration);
//            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
//
//            DLog(@"duration.value=%lld,duration.timescale=%d",duration.value,duration.timescale);
//            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
            [self didChangeStatusToReadyPlay:YES duration:totalSecond message:GMVideoPlayerReadyToPlayMessage];
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            //NSLog(@"AVPlayerStatusFailed");
            [self didChangeStatusToReadyPlay:NO duration:0 message:GMVideoPlayerNotReadyMessage];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        //DLog(@"Time Interval:%f",timeInterval);
        [self didLoadTimeRanges:timeInterval];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)customVideoSlider:(CMTime)duration {
    //设备slider的最大，最小值
    //    self.videoSlider.maximumValue = duration;
    //    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    //    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    [self.videoSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    //    [self.videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

- (IBAction)stateButtonTouched:(id)sender {
    //点击播放按键的响应函数
    //    if (!_played) {
    //        [self.playerView.player play];
    //        [self.stateButton setTitle:@"Stop" forState:UIControlStateNormal];
    //    } else {
    //        [self.playerView.player pause];
    //        [self.stateButton setTitle:@"Play" forState:UIControlStateNormal];
    //    }
    //    _played = !_played;
}

- (IBAction)videoSlierChangeValue:(id)sender {
    //slider值变化的响应函数
    //    UISlider *slider = (UISlider *)sender;
    //    NSLog(@"value change:%f",slider.value);
    //
    //    if (slider.value == 0.000000) {
    //        __weak typeof(self) weakSelf = self;
    //        [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
    //            [weakSelf.playerView.player play];
    //        }];
    //    }
}

- (IBAction)videoSlierChangeValueEnd:(id)sender {
    //slider接到最值时的响应函数
    //    UISlider *slider = (UISlider *)sender;
    //    NSLog(@"value end:%f",slider.value);
    //    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
    //
    //    __weak typeof(self) weakSelf = self;
    //    [self.playerView.player seekToTime:changedTime completionHandler:^(BOOL finished) {
    //        [weakSelf.playerView.player play];
    //        [weakSelf.stateButton setTitle:@"Stop" forState:UIControlStateNormal];
    //    }];
}

- (void)updateVideoSlider:(CGFloat)currentSecond {
    //更改slider 拉柄的位置
    //    [self.videoSlider setValue:currentSecond animated:YES];
}


- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    
    [self didPlayEnd];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [self.dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}




- (void)playVideo{
    
    [self.player play];
}



- (void)stopVideo{
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}

- (void)closeVideo{
    [self stopVideo];
    

    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    if( self.playbackTimeObserver != nil ){
        [self.player removeTimeObserver:self.playbackTimeObserver];
        self.playbackTimeObserver = nil;
    }
    
    [self.playerItem removeOutput:self.videoOutput];

    self.playerItem = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    
    //self.playButton.hidden = YES;
    self.videoUrl = nil;
}

- (void)pauseVideo{
    [self.player pause];
}

- (void)seekToPosition:(CGFloat)position{
    NSLog(@"timescale=%d",self.playerItem.duration.timescale);
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(position, self.playerItem.duration.timescale)];
}


#pragma mark- AVPlayerItemOutputPullDelegate <NSObject>



/*!
 @method            outputMediaDataWillChange:
 @abstract        A method invoked once, prior to a new sample, if the AVPlayerItemOutput sender was previously messaged requestNotificationOfMediaDataChangeWithAdvanceInterval:.
 @discussion
 This method is invoked once after the sender is messaged requestNotificationOfMediaDataChangeWithAdvanceInterval:.
 */

- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender{
    NSLog(@"sender=%@",sender);
}

/*!
 @method            outputSequenceWasFlushed:
 @abstract        A method invoked when the output is commencing a new sequence.
 @discussion
 This method is invoked after any seeking and change in playback direction. If you are maintaining any queued future samples, copied previously, you may want to discard these after receiving this message.
 */

- (void)outputSequenceWasFlushed:(AVPlayerItemOutput *)output{
    
}

@end
