//
//  VOImagePickerViewController.m
//  VideoOnline
//
//  Created by Bias.Xie on 15-1-26.
//  Copyright (c) 2015年 Goman. All rights reserved.
//

#import "VOImagePickerViewController.h"

@interface VOImagePickerViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,readwrite,copy) NSString *promptTitle;
@property (nonatomic) UIImagePickerController *picker;

@end

@implementation VOImagePickerViewController

- (id)initWithPromptTitle:(NSString *)promptTitle
{
    self = [super init];
    if( self ){
        self.promptTitle = promptTitle;
    }
    return self;
}

- (id)init
{
    return [self initWithPromptTitle:nil];
}

- (void)dealloc
{
    [self hide];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showInParentViewController:(UIViewController *)parentViewController
{
    if( self.parentViewController != nil )
    {
        return;
    }
    [parentViewController addChildViewController:self];
    
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
/////////////////////////
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:self.promptTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    
    [sheet showInView:self.view];
}

- (void)hide
{
    if( self.parentViewController == nil )
    {
        return;
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIActionSheetDelegate
- (void)showPickerWithCompletion:( void (^)(void))completion{
    CGRect pickerFrame = self.view.bounds;
    pickerFrame.origin.y += pickerFrame.size.height;
    self.picker.view.frame = pickerFrame;
    [self.view addSubview:self.picker.view];
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        self.picker.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        if( completion )
        {
            completion();
        }
    }];
}

- (void)hidePickerWithCompletion:( void (^)(void))completion{
    CGRect pickerFrame = self.view.bounds;
    pickerFrame.origin.y += pickerFrame.size.height;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        self.picker.view.frame = pickerFrame;
    } completion:^(BOOL finished) {
        [self.picker.view removeFromSuperview];
        if( completion )
        {
            completion();
        }
    }];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    // 启动相机
    if (buttonIndex == 0)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ( [UIImagePickerController isSourceTypeAvailable:sourceType] )
        {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.picker.delegate = self;
            self.picker.allowsEditing = YES;
            self.picker.sourceType = sourceType;
            
            
            [self showPickerWithCompletion:nil];
           // [self presentViewController:self.picker animated:YES completion:nil];
            
//            double delayInSeconds = 0.1;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self presentViewController:picker animated:YES completion:nil];
//            });

        }
    }
    // 启动相册
    else if (buttonIndex == 1) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if ( [UIImagePickerController isSourceTypeAvailable:sourceType] )
        {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.picker.allowsEditing = NO;
            self.picker.sourceType = sourceType;
            //UIImagePickerControllerOriginalImage
  
            [self showPickerWithCompletion:nil];
        }
    }

    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 2 )
    {
        [self hide];
        [self.delegate imagePickerViewControllerDidCancelButton:self];
 
    }
}

#pragma mark - UINavigationControllerDelegata & UIImagePickerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 取得选择的照片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if ( !image ) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    // 关闭相册
    
    __weak VOImagePickerViewController *weakSelf = self;
    [self hidePickerWithCompletion:^{
        [weakSelf hide];
        [weakSelf.delegate imagePickerViewController:weakSelf didPickImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak VOImagePickerViewController *weakSelf = self;
    [self hidePickerWithCompletion:^{
        [weakSelf hide];
        [weakSelf.delegate imagePickerViewControllerDidCancelButton:self];
    }];

}


@end
