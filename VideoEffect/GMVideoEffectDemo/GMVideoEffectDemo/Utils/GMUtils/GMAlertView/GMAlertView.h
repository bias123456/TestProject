//
//  GMAlertView.h
//  GLDVRModule
//
//  Created by BBias Xie on 2018/12/21.
//  Copyright © 2018年 BBias Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GMAlertView;

typedef void (^GMAlertViewHandler)(GMAlertView *alertView , NSInteger buttonIndex );

@interface GMAlertView : UIView

+ (void)showAlertViewInParentView:(UIView *)parentView title:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle buttonTitles:(NSArray *)buttonTitles handler:(GMAlertViewHandler)handler;
@end

NS_ASSUME_NONNULL_END
