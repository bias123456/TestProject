//
//  GMVideoService.m
//  FifteenSeconds
//
//  Created by BBias Xie on 2019/1/21.
//  Copyright © 2019 TapHarmonic, LLC. All rights reserved.
//

#import "GMVideoService.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

@implementation GMVideoService

+ (instancetype)sharedService{
    static id sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}

- (void)videoCompostionWithUrl:(NSURL *)url{
    

    
 
    

        

    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    NSLog(@"tracks=%@",asset.tracks);
    
    //AVComposition *composition = [AVComposition assetWithURL:url]; //AVComposition使用assetWithURL会失败
    AVVideoComposition *videoComposition =
    [AVMutableVideoComposition
     videoCompositionWithPropertiesOfAsset:asset];
    for( AVVideoCompositionInstruction *videoCompositionInstruction in videoComposition.instructions ){
        for( AVVideoCompositionLayerInstruction *videoCompositionLayerInstruction in videoCompositionInstruction.layerInstructions ){
            NSLog(@"videoCompositionInstruction=%@,videoCompositionLayerInstruction=%@",videoCompositionInstruction,videoCompositionLayerInstruction);
        }
    }
}

- (void)addFilterWithUrl:(NSURL *)url{
    
    AVAsset *videoAsset = [AVAsset assetWithURL:url];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset:videoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        NSLog(@"导出中");
        CIImage*source = request.sourceImage;
        [filter setValue:source forKey:@"inputImage"];
        CIImage*resultImage = [filter valueForKey:@"outputImage"];
        [request finishWithImage:resultImage context:nil];
    }];
    
    
    
}


- (AVPlayerItem *)test2{
    
    
    
    
    NSURL *url_1 = [[NSBundle mainBundle] URLForResource:@"01_nebula.mp4" withExtension:nil];
    NSURL *url_2 = [[NSBundle mainBundle] URLForResource:@"03_nebula.mp4" withExtension:nil];
    NSURL *url_3 = [[NSBundle mainBundle] URLForResource:@"04_quasar.mp4" withExtension:nil];
    
    AVAsset *asset_1 = [AVAsset assetWithURL:url_1];
    AVAsset *asset_2 = [AVAsset assetWithURL:url_2];
    AVAsset *asset_3 = [AVAsset assetWithURL:url_3];
    NSArray *assetList = @[asset_1,asset_2,asset_3];
    
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionTrack_1 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionTrack_2 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionTrack_3 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *compositionTrackList = @[compositionTrack_1,compositionTrack_2,compositionTrack_3];
    
    for( NSInteger i = 0 ; i < 3 ; i++ ){
        AVAsset *asset = assetList[i];
        AVMutableCompositionTrack *compositionTrack = compositionTrackList[i];
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        [compositionTrack insertTimeRange:timeRange ofTrack:assetTrack atTime:kCMTimeZero error:nil];
    }
    
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset_1.duration);
    
    AVMutableVideoComposition *videoComposition =                           // 1
    [AVMutableVideoComposition
     videoCompositionWithPropertiesOfAsset:composition];
    NSMutableArray *transitionInstructions = [[NSMutableArray alloc] init];
    
    AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    CGRect rect1 = CGRectMake(0, 0*0.3*videoComposition.renderSize.height, videoComposition.renderSize.width, 0.3*videoComposition.renderSize.height);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[[asset_1 tracksWithMediaType:AVMediaTypeVideo] firstObject]];
    [videoCompositionLayerInstruction_1 setCropRectangle:rect1 atTime:kCMTimeZero];
    
    CGRect rect2 = CGRectMake(0, 1*0.3*videoComposition.renderSize.height, videoComposition.renderSize.width, 0.3*videoComposition.renderSize.height);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[[asset_2 tracksWithMediaType:AVMediaTypeVideo] firstObject]];
    [videoCompositionLayerInstruction_2 setCropRectangle:rect2 atTime:kCMTimeZero];
    
    
    CGRect rect3 = CGRectMake(0, 2*0.3*videoComposition.renderSize.height, videoComposition.renderSize.width, 0.3*videoComposition.renderSize.height);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_3 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[[asset_3 tracksWithMediaType:AVMediaTypeVideo] firstObject]];
    [videoCompositionLayerInstruction_3 setCropRectangle:rect3 atTime:kCMTimeZero];
    
    
    videoCompositionInstruction.timeRange = timeRange;
    videoCompositionInstruction.layerInstructions = @[videoCompositionLayerInstruction_1,videoCompositionLayerInstruction_1,videoCompositionLayerInstruction_2,videoCompositionLayerInstruction_3];
    
    [transitionInstructions addObject:videoCompositionInstruction];
    videoComposition.instructions = transitionInstructions;
    
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:[composition copy]];
    item.videoComposition = videoComposition;
    
    return item;
    
}

- (void)test1{
    //01_nebula.mp4
    //push_wipe.m4v

    
    
    
    
    NSLog(@"---------------------Source Video------------------------------");
    NSURL *url_src = [[NSBundle mainBundle] URLForResource:@"01_nebula.mp4" withExtension:nil];
    
    NSData *data_src = [NSData dataWithContentsOfURL:url_src];
    [self videoCompostionWithUrl:url_src];
    
    NSLog(@"---------------------Destination Video------------------------------");
    NSURL *url_dst = [[NSBundle mainBundle] URLForResource:@"push_wipe.m4v" withExtension:nil];
    [self videoCompostionWithUrl:url_dst];

}

@end
