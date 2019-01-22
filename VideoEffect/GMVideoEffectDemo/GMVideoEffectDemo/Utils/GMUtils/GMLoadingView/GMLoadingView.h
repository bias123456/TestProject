//
//  GMLoadingView.h
//  GLDVRModule
//
//  Created by BBias Xie on 2018/12/18.
//  Copyright © 2018年 BBias Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^GMLoadingViewTimeoutBlock)(void);

@interface GMLoadingView : UIView

+ (instancetype)loadingViewInParentView:(UIView *)parentView text:(NSString *)text duration:(NSTimeInterval)duration timeoutBlock:(GMLoadingViewTimeoutBlock)timeoutBlock;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
