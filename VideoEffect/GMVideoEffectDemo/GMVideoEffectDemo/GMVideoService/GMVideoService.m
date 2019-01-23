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
    
    CMTime duration_1 = asset_1.duration;
    CMTime duration_2 = asset_2.duration;
    CMTime duration_3 = asset_3.duration;
    CMTime duration = CMTimeMinimum(duration_1, duration_2);
    duration = CMTimeMinimum(duration, duration_3);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionTrack_1 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionTrack_2 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionTrack_3 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *compositionTrackList = @[compositionTrack_1,compositionTrack_2,compositionTrack_3];
    

    NSError *error;
    AVAssetTrack *assetTrack_1 = [[asset_1 tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [compositionTrack_1 insertTimeRange:timeRange ofTrack:assetTrack_1 atTime:kCMTimeZero error:&error];
    

    AVAssetTrack *assetTrack_2 = [[asset_2 tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [compositionTrack_2 insertTimeRange:timeRange ofTrack:assetTrack_2 atTime:kCMTimeZero error:&error];
    
    AVAssetTrack *assetTrack_3 = [[asset_3 tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [compositionTrack_3 insertTimeRange:timeRange ofTrack:assetTrack_3 atTime:kCMTimeZero error:nil];
    
    AVMutableVideoComposition *videoComposition =                           // 1
    [AVMutableVideoComposition
     videoCompositionWithPropertiesOfAsset:[composition copy]];
    NSMutableArray *transitionInstructions = [[NSMutableArray alloc] init];
    
    AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    CGAffineTransform identityTransform = CGAffineTransformIdentity;
    CGFloat targetHeight = 0.33333*videoComposition.renderSize.height;
    
    CGRect rect_1 = CGRectMake(0, targetHeight, videoComposition.renderSize.width, 0.3*videoComposition.renderSize.height);
    CGAffineTransform transform_1 = CGAffineTransformTranslate(identityTransform, 0, -1*targetHeight);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack_1];
    [videoCompositionLayerInstruction_1 setCropRectangleRampFromStartCropRectangle:rect_1 toEndCropRectangle:rect_1 timeRange:timeRange];
    [videoCompositionLayerInstruction_1 setTransformRampFromStartTransform:transform_1 toEndTransform:transform_1 timeRange:timeRange];
    
    
    CGRect rect_2 = CGRectMake(0, targetHeight, videoComposition.renderSize.width, 0.3*videoComposition.renderSize.height);
    CGAffineTransform transform_2 = CGAffineTransformTranslate(identityTransform, 0, 0*targetHeight);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack_2];
    [videoCompositionLayerInstruction_2 setCropRectangleRampFromStartCropRectangle:rect_2 toEndCropRectangle:rect_2 timeRange:timeRange];
    [videoCompositionLayerInstruction_2 setTransformRampFromStartTransform:transform_2 toEndTransform:transform_2 timeRange:timeRange];
    
    
    CGRect rect_3 = CGRectMake(0, targetHeight, videoComposition.renderSize.width, 0.3*videoComposition.renderSize.height);
    CGAffineTransform transform_3 = CGAffineTransformTranslate(identityTransform, 0, 1*targetHeight);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_3 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack_3];
    [videoCompositionLayerInstruction_3 setCropRectangleRampFromStartCropRectangle:rect_3 toEndCropRectangle:rect_3 timeRange:timeRange];
    [videoCompositionLayerInstruction_3 setTransformRampFromStartTransform:transform_3 toEndTransform:transform_3 timeRange:timeRange];
    
    
    videoCompositionInstruction.timeRange = timeRange;
    videoCompositionInstruction.layerInstructions = @[videoCompositionLayerInstruction_1,videoCompositionLayerInstruction_2,videoCompositionLayerInstruction_3];
    
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
