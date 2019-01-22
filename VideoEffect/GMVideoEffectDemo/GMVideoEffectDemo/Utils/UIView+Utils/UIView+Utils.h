//
//  UIView+Utils.h
//  Inspection
//
//  Created by Bias.Xie on 17/8/28.
//  Copyright © 2017年 Gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

- (void)makeCircleBorderWithColor:(UIColor *)color;
- (void)makeCircleBorder;//圆形边界,边界色为[UIColor clearColor]
- (void)makeBorderCornerWithColor:(UIColor *)color;
- (void)makeBorderCornerWithRadius:(CGFloat)radius; //绘制圆角效果
- (void)makeBorderCorner; //radius = 5;
- (void)makeBorderCornerWithColor:(UIColor *)color radius:(NSInteger)radius;
@end
