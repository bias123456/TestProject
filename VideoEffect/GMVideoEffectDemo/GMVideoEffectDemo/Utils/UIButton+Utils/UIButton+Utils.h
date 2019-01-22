//
//  UIButton+Utils.h
//  smartshop
//
//  Created by Bias.Xie on 29/05/2018.
//  Copyright © 2018 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utils)

- (void)setupWithTitleAtLeftStyle;
- (void)setupWithTitleAtBottomStyle;

- (void)setupForControlButton;
- (void)startCountDownWithSecond:(NSInteger)count;


@end
