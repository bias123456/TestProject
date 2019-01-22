//
//  GMAlertView.m
//  GLDVRModule
//
//  Created by BBias Xie on 2018/12/21.
//  Copyright © 2018年 BBias Xie. All rights reserved.
//

#import "GMAlertView.h"

@interface GMAlertView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (copy,nonatomic) GMAlertViewHandler handle;

@end

@implementation GMAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)newView{
    GMAlertView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return view;
}

- (void)dealloc{
    DLog(@"GMAlertView dealloc------------");
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.contentView makeBorderCornerWithRadius:10];

}

+ (void)showAlertViewInParentView:(UIView *)parentView title:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle buttonTitles:(NSArray *)buttonTitles handler:(GMAlertViewHandler)handler{
    
    GMAlertView *alertView = [self newView];
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    alertView.handle = handler;
    
    alertView.frame = parentView.bounds;
    [parentView addSubview:alertView];
}

- (IBAction)onCancelButtonTouchUpInside:(id)sender{
    if( self.handle ){
        
        self.handle(self, 0);
        [self removeFromSuperview];
    }
}

- (IBAction)onConfirmButtonTouchUpInside:(id)sender{
    if( self.handle ){
        self.handle(self, 1);
        [self removeFromSuperview];
    }
}

@end
