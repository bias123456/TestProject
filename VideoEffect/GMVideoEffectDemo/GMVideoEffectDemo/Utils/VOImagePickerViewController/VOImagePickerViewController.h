//
//  VOImagePickerViewController.h
//  VideoOnline
//
//  Created by Bias.Xie on 15-1-26.
//  Copyright (c) 2015年 Goman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VOImagePickerViewControllerDelegate;

@interface VOImagePickerViewController : UIViewController

///初始化控件，并且设置控件的title
- (id)initWithPromptTitle:(NSString *)promptTitle;
///初始化控件，不设置控件的title
- (id)init;
///控件的title
@property (nonatomic,readonly,copy) NSString *promptTitle;

///控件事件返回的delegate
@property(nonatomic,assign) id <VOImagePickerViewControllerDelegate> delegate;
///显示控件
- (void)showInParentViewController:(UIViewController *)parentViewController;
//- (void)hide;

@end

@protocol VOImagePickerViewControllerDelegate <NSObject>

///选择图片后的返回事件
- (void)imagePickerViewController:(VOImagePickerViewController *)controller didPickImage:(UIImage *)image;
///用户取消图片选择操作的事件
- (void)imagePickerViewControllerDidCancelButton:(VOImagePickerViewController *)controller;

@end
