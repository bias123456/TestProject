//
//  GMVideoPlayerProtocol.h
//  ActU
//
//  Created by Bias.Xie on 2018/1/4.
//  Copyright © 2018年 Juer. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM (NSInteger,GMVideoPlayerStatus){
    GMVideoPlayerStatusNotReady = 0,
    GMVideoPlayerStatusReadyToPlay = 1,
    GMVideoPlayerStatusPlayEnd = 2
};

typedef NS_ENUM(NSInteger,GMVideoPlayerTimeControlState){
    GMVideoPlayerTimeControlStatePause=0,
    GMVideoPlayerTimeControlStatePlaying=1,
};

static NSString * const GMVideoPlayerReadyToPlayMessage = @"视频已准备就绪。";
static NSString * const GMVideoPlayerNotReadyMessage = @"视频准备过程中出现异常。";

@protocol GMVideoPlayerDelegate;

@protocol GMVideoPlayerProtocol <NSObject>


@required
@property (nonatomic,readwrite,assign) id <GMVideoPlayerDelegate> playerDelegate;

@property (nonatomic,readonly,assign) GMVideoPlayerStatus playerStatus; // 状态
@property (nonatomic,readonly,assign) NSTimeInterval duration; //视频总长度
@property (nonatomic,readonly,assign) NSTimeInterval currentPosition; //当前播放位置
@property (nonatomic,readonly,assign) NSTimeInterval loadedTimeRanges; //当前已下载(播放器已缓冲)的长度
@property (nonatomic,readonly,assign) GMVideoPlayerTimeControlState controlstate;
@property (nonatomic) float volume NS_AVAILABLE(10_7, 7_0);
@property (nonatomic) BOOL muted;

@property (nonatomic,readonly,copy) NSString *videoUrl;
- (void)openVideoWithUrl:(NSString *)videoUrl;
- (void)playVideo;
- (void)stopVideo;
- (void)closeVideo;

- (void)pauseVideo;
- (void)seekToPosition:(CGFloat)position;
@end

@protocol GMVideoPlayerDelegate

@required
- (void)gmVideoPlayer:(NSObject *)player didChangeStatusToReadyPlay:(BOOL)isSuccess duration:(NSTimeInterval)duration message:(NSString *)message;
- (void)gmVideoPlayer:(NSObject *)player didPlayToPosition:(NSTimeInterval)currentPosition;
- (void)gmVideoPlayer:(NSObject *)player didLoadTimeRanges:(NSTimeInterval)loadTimeRanges;
- (void)gmVideoPlayerDidPlayEnd:(NSObject *)player;

@end
