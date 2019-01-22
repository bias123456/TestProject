//
//  UIView+Utils.m
//  Inspection
//
//  Created by Bias.Xie on 17/8/28.
//  Copyright © 2017年 Gemo. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)makeCircleBorderWithColor:(UIColor *)color{
    self.layer.cornerRadius = 0.5*MIN(self.bounds.size.width,self.bounds.size.height);
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)makeCircleBorder{
    self.layer.cornerRadius = 0.5*MIN(self.bounds.size.width,self.bounds.size.height);
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)makeBorderCornerWithRadius:(CGFloat)radius{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)makeBorderCornerWithColor:(UIColor *)color{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)makeBorderCorner{
    [self makeBorderCornerWithRadius:5];
}

- (void)makeBorderCornerWithColor:(UIColor *)color radius:(NSInteger)radius{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

@end
