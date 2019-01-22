//
//  AVVideoPlayerViewController.h
//  ActU
//
//  Created by Bias.Xie on 2018/1/4.
//  Copyright © 2018年 Juer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVKit/AVKit.h"
#import "GMVideoPlayerProtocol.h"




@interface AVVideoPlayerViewController : UIViewController <GMVideoPlayerProtocol>

- (instancetype)init;

@property (nonatomic,readwrite,assign) id <GMVideoPlayerDelegate> playerDelegate;
@property (nonatomic,readonly,assign) GMVideoPlayerStatus playerStatus; // 状态
@property (nonatomic,readonly,assign) NSTimeInterval duration; //视频总长度
@property (nonatomic,readonly,assign) NSTimeInterval currentPosition; //当前播放位置
@property (nonatomic,readonly,assign) NSTimeInterval loadedTimeRanges; //当前已下载(播放器已缓冲)的长度
@property (nonatomic,readonly,assign) GMVideoPlayerTimeControlState controlstate;
@property (nonatomic) float volume NS_AVAILABLE(10_7, 7_0);
@property (nonatomic) BOOL muted;

@property (nonatomic,readonly,copy) NSString *videoUrl;
@property (nonatomic,readonly,strong) AVPlayerItem *playerItem;
- (void)openVideoWithUrl:(NSString *)videoUrl;
- (void)openWithPlayerItem:(AVPlayerItem *)item;
- (void)playVideo;
- (void)stopVideo;
- (void)closeVideo;

- (void)pauseVideo;
- (void)seekToPosition:(CGFloat)position;
- (void)updatePlayerLayerRegion;


@end


