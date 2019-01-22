//
//  GMVideoService.m
//  FifteenSeconds
//
//  Created by BBias Xie on 2019/1/21.
//  Copyright © 2019 TapHarmonic, LLC. All rights reserved.
//

#import "GMVideoService.h"
#import <AVFoundation/AVFoundation.h>

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
    
    AVPlayerItem *item;
    //item.
    
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
