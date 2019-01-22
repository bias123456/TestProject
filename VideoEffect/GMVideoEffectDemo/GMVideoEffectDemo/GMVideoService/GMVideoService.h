//
//  GMVideoService.h
//  FifteenSeconds
//
//  Created by BBias Xie on 2019/1/21.
//  Copyright © 2019 TapHarmonic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMVideoService : NSObject

+ (instancetype)sharedService;
- (AVPlayerItem *)test2;
- (void)test1;

@end

NS_ASSUME_NONNULL_END
