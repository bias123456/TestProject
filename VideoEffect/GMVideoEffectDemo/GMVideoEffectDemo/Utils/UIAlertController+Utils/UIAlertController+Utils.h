//
//  UIAlertController+Utils.h
//  Justice
//
//  Created by Bias.Xie on 17/9/26.
//  Copyright © 2017年 Gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Utils)

///创建AlertController,其中buttonTitles各按键名称列表，最少要包括一个按键的名称。并且第一个按键规定为cancel按键的名称
+ (nullable instancetype)easyAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle buttonTitles:(nonnull NSArray *)buttonTitles handler:(void (^ __nullable)(UIAlertController * _Nullable alertController, NSInteger buttonIndex))handler;
///创建AlertController,其中buttonTitles可变数量按键名称，最少要包括一个按键的名称，最后以nil关键字结束。并且第一个按键规定为cancel按键的名称
+ (nullable instancetype)easyAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void (^ __nullable)(UIAlertController * _Nullable alertController,NSInteger buttonIndex))handler buttonTitles:(nonnull NSString *)cancelButtonTitle,...NS_REQUIRES_NIL_TERMINATION;
///在parentViewController上显示一个简单的AlertView,alert的内容为message
+ (void)showAlertInViewController:(UIViewController *_Nullable)parentViewController withMessage:(NSString *_Nullable)message;
@end
