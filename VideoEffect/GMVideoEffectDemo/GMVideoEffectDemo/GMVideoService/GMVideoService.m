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
#import <UIKit/UIKit.h>


#ifndef WS
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#endif

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

- (AVPlayerItem *)makeCombinedVideo{
    return [self makeCombinedVideo_1];
}

- (void)test{
    AVQueuePlayer *player = nil;
}

- (AVPlayerItem *)makeCombinedVideo_1{
    NSError *error;
    AVMutableComposition *composition = [AVMutableComposition composition];
    NSArray *fileNameList = @[@"04_quasar.mp4",@"01_nebula.mp4",@"03_nebula.mp4"];
    for( NSString *fileName in fileNameList ){
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        
        AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionTrack insertTimeRange:assetTrack.timeRange ofTrack:assetTrack atTime:kCMTimeZero error:&error];
    }
    
    AVVideoComposition *videoComposition = [AVVideoComposition videoCompositionWithPropertiesOfAsset:composition];
    
//    AVVideoComposition *videoComposition_filter = [AVVideoComposition videoCompositionWithAsset:composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
//
//        CIImage *inputImage = request.sourceImage;
//        CIFilter *filter = [CIFilter filterWithName:@"CICircularWrap"];
//        [filter setValue:inputImage forKey:@"inputImage"];
//        [filter setDefaults];
//        //可以加多个滤镜
//
//        CIImage* outputImage = [filter valueForKey:@"outputImage"];
//
//
//        if( outputImage != nil ){
//            [request finishWithImage:outputImage context:nil];
//        }else{
//            NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-1 userInfo:nil];
//            [request finishWithError:error];
//        }
//
//    }];
    

    
 
    NSArray *instructions = videoComposition.instructions;
    for( AVVideoCompositionInstruction *instruction in instructions ){
        NSLog(@"instruction=%@",instruction);
        NSLog(@"instruction class=%@",[instruction class]);
        NSArray *layerInstructions = instruction.layerInstructions;
        NSInteger layerInstructionsCount = layerInstructions.count;
        for( NSInteger layerInstructionsIndex=0 ; layerInstructionsIndex<layerInstructionsCount ; layerInstructionsIndex++ ){
            AVMutableVideoCompositionLayerInstruction *layerInstruction = layerInstructions[layerInstructionsIndex];
            NSLog(@"layerInstruction=%@",layerInstruction);
            CGFloat layerHeight = videoComposition.renderSize.height/layerInstructionsCount;
            CGRect rect;
            rect.origin.x = 0;
            rect.size.width = videoComposition.renderSize.width-rect.origin.x;
            rect.size.height = layerHeight;
            rect.origin.y = 0.5 * (videoComposition.renderSize.height-rect.size.height);//取中间位置
            [layerInstruction setCropRectangleRampFromStartCropRectangle:rect toEndCropRectangle:rect timeRange:instruction.timeRange];
            
            CGFloat ty=0;
            if( (layerInstructionsCount % 2) == 1 ){
                //奇数
                ty = layerHeight * (0.0 + (layerInstructionsIndex-layerInstructionsCount/2));
            }else{
                //偶数
                ty = layerHeight * (0.5 + (layerInstructionsIndex-layerInstructionsCount/2));
            }
            CGAffineTransform startTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, ty);
            CGAffineTransform endTransform;
        
            if( ((layerInstructionsCount % 2) == 1) && (layerInstructionsIndex == (layerInstructionsCount/2))){
                //当layerInstructionsCount为奇数个，并且layerInstructionsIndex为中间的时候
                endTransform = CGAffineTransformTranslate(startTransform, videoComposition.renderSize.width, 0);
            }else{
                endTransform = startTransform;
            }
            

            [layerInstruction setTransformRampFromStartTransform:startTransform toEndTransform:endTransform timeRange:instruction.timeRange];
        }

    }
 
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:composition];
    item.videoComposition = videoComposition;
    
    
    
    return item;
}

- (AVPlayerItem *)makeCombinedVideo_0{
    

    
    
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
    
    

    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:[composition copy]];
    
//    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
//
//            CIImage *inputImage = request.sourceImage;
//            CIFilter *filter = [CIFilter filterWithName:@"CICircularWrap"];
//            [filter setValue:inputImage forKey:@"inputImage"];
//            [filter setDefaults];
//            //可以加多个滤镜
//
//            CIImage* outputImage = [filter valueForKey:@"outputImage"];
//
//
//            if( outputImage != nil ){
//                [request finishWithImage:outputImage context:nil];
//            }else{
//                NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-1 userInfo:nil];
//                [request finishWithError:error];
//            }
//
//        }];
    
    
    
    
    
    
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
    CGAffineTransform transform_2_end = CGAffineTransformTranslate(transform_2, videoComposition.renderSize.width, 0);
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction_2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack_2];
    [videoCompositionLayerInstruction_2 setCropRectangleRampFromStartCropRectangle:rect_2 toEndCropRectangle:rect_2 timeRange:timeRange];
    [videoCompositionLayerInstruction_2 setTransformRampFromStartTransform:transform_2 toEndTransform:transform_2_end timeRange:timeRange];
    
    
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

- (AVSynchronizedLayer *)createOverlapSubjectsForPlayerItem:(AVPlayerItem *)item bounds:(CGRect)bounds{
    AVSynchronizedLayer *syncLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:item];
    syncLayer.bounds = bounds;
    syncLayer.position = CGPointMake(CGRectGetMidX(bounds),
                                     CGRectGetMidY(bounds));
    
    
    CALayer *titleLayer = [self buildTitleLayerWithBounds:bounds];
    CAAnimation *animation = [self makeFadeInFadeOutAnimationStartTiem:CMTimeGetSeconds(kCMTimeZero) duration:CMTimeGetSeconds(item.asset.duration) bounds:bounds];
    [titleLayer addAnimation:animation forKey:nil];
    
    
    [syncLayer addSublayer:titleLayer];
    
    return syncLayer;
}


- (CALayer *)makeTextLayerWithText:(NSString *)text position:(CGPoint)position{
    
    CGFloat fontSize = 20.0f;
    UIFont *font = [UIFont fontWithName:@"GillSans-Bold" size:fontSize];
    
    NSDictionary *attrs =
    @{NSFontAttributeName            : font,
      NSForegroundColorAttributeName : (id) [UIColor yellowColor].CGColor};
    
    NSAttributedString *string =
    [[NSAttributedString alloc] initWithString:text attributes:attrs];
    
    CGSize textSize = [text sizeWithAttributes:attrs];
    
    CATextLayer *layer = [CATextLayer layer];
    layer.string = string;
    layer.bounds = CGRectMake(0.0f, 0.0f, textSize.width, textSize.height);
    layer.position = position;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
    return layer;
}

- (CAAnimation *)makeFadeInFadeOutAnimationStartTiem:(CGFloat)startTime duration:(CGFloat)duration bounds:(CGRect)bounds{
    
    //animation.values = @[@0.0f, @0.99];
    //animation.keyTimes = @[@0.0f, @1.0f];
    //    animation.values = @[@0.0f, @1.0, @1.0f, @0.0f];
    //    animation.keyTimes = @[@0.0f, @0.25f, @0.75f, @1.0f];
    
//    CABasicAnimation *animation =
//    [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.fromValue = @(0.0f);
//    animation.toValue = @(1.0f);
    
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"bounds"];
    CGRect bounds_start = bounds;
    //bounds_start.origin.x += 0.5*bounds.size.width;
    bounds_start.size.width = 0;
    
    animation.fromValue = [NSValue valueWithCGRect:bounds_start];
    animation.toValue = [NSValue valueWithCGRect:bounds];
    
    
    animation.beginTime =  (startTime<FLT_EPSILON)?AVCoreAnimationBeginTimeAtZero:startTime;//startTime;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (CALayer *)buildTitleLayerWithBounds:(CGRect)bounds {
    
//    CGPoint position = CGPointMake(CGRectGetMidX(bounds),
//                                       CGRectGetMidY(bounds));
//    CALayer *ret = [self makeTextLayerWithText:@"视频效果测试程序" position:position];
//    return ret;

    
    CALayer *titleLayer = [CALayer layer];                              // 2
    titleLayer.bounds = bounds;
    titleLayer.anchorPoint = CGPointZero;
    titleLayer.masksToBounds = YES;
    titleLayer.backgroundColor = [UIColor clearColor].CGColor;
    titleLayer.position =CGPointZero;// CGPointMake(CGRectGetMidX(bounds),CGRectGetMidY(bounds));
    
    CGPoint textPosition = CGPointMake(CGRectGetMidX(bounds),CGRectGetMidY(bounds));
    CALayer *textlayer = [self makeTextLayerWithText:@"视频效果测试程序" position:textPosition];
    [titleLayer addSublayer:textlayer];
    
    return titleLayer;
}


- (void)makeExportableWithPlayerItem:(AVPlayerItem *)playerItem titleLayer:(CALayer *)titleLayer viewBounds:(CGRect)viewBounds{

    AVAsset *asset = playerItem.asset;
    AVMutableVideoComposition *videoComposition = (AVMutableVideoComposition *)(playerItem.videoComposition);
        
    CALayer *animationLayer = [CALayer layer];                          // 1
    animationLayer.frame = viewBounds;
        
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0,videoComposition.renderSize.width , videoComposition.renderSize.height);;
        
    [animationLayer addSublayer:videoLayer];                            // 2
    [animationLayer addSublayer:titleLayer];
        
    animationLayer.geometryFlipped = YES;                              // 3
        
    AVVideoCompositionCoreAnimationTool *animationTool =                // 4
        [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                                                                                     inLayer:animationLayer];

    videoComposition.animationTool = animationTool;                                  // 5
    
    
    NSString *presetName = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *session =
    [[AVAssetExportSession alloc] initWithAsset:[asset copy] presetName:presetName];
    //session.audioMix = self.audioMix;
    session.videoComposition = videoComposition;
    
    
    session.outputURL = [self exportURL];
    session.outputFileType = AVFileTypeMPEG4;
    [session exportAsynchronouslyWithCompletionHandler:^{        // 2
        
        dispatch_async(dispatch_get_main_queue(), ^{                        // 1
            AVAssetExportSessionStatus status = session.status;
            if (status == AVAssetExportSessionStatusCompleted) {
                //[self writeExportedVideoToAssetsLibrary];
                UISaveVideoAtPathToSavedPhotosAlbum(session.outputURL.absoluteString, nil, nil, NULL);
            } else {
                NSLog(@"导出失败。");
            }
        });
    }];
}





- (NSURL *)exportURL {                                                      // 5
    NSString *filePath = nil;
    NSUInteger count = 0;
    do {
        filePath = NSTemporaryDirectory();
        NSString *numberString = count > 0 ?
        [NSString stringWithFormat:@"-%li", (unsigned long) count] : @"";
        NSString *fileNameString =
        [NSString stringWithFormat:@"Masterpiece-%@.m4v", numberString];
        filePath = [filePath stringByAppendingPathComponent:fileNameString];
        count++;
    } while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    return [NSURL fileURLWithPath:filePath];
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

- (void)addFilter{
    
    AVAsset *asset = nil;
    [AVMutableVideoComposition videoCompositionWithAsset:asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        
        CIImage *inputImage = request.sourceImage;
        CIFilter *filter = [CIFilter filterWithName:@"my_filter"];
        [filter setValue:inputImage forKey:@"inputImage"];
        //可以加多个滤镜
        
        CIImage* outputImage = [filter valueForKey:@"outputImage"];

        if( outputImage != nil ){
            [request finishWithImage:outputImage context:nil];
        }else{
            NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-1 userInfo:nil];
            [request finishWithError:error];
        }
        
    }];
//    AVMutableComposition
//    AVComposition
//    AVCaptureSession
    //AVAudioSession
    //AVCaptureMovieFileOutput
}

@end
