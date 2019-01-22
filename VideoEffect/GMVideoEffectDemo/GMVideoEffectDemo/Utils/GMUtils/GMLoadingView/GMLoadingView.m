//
//  GMLoadingView.m
//  GLDVRModule
//
//  Created by BBias Xie on 2018/12/18.
//  Copyright © 2018年 BBias Xie. All rights reserved.
//

#import "GMLoadingView.h"

@interface GMLoadingView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (assign) NSTimeInterval duration;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, copy) GMLoadingViewTimeoutBlock timeoutBlock;

@end

@implementation GMLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)newView{
    GMLoadingView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return view;
}



+ (instancetype)loadingViewInParentView:(UIView *)parentView text:(NSString *)text duration:(NSTimeInterval)duration timeoutBlock:(GMLoadingViewTimeoutBlock)timeoutBlock{
    GMLoadingView *loadingView = [self newView];
    loadingView.frame = parentView.bounds;
    [parentView addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@(0));
    }];
    loadingView.textLabel.text = text;
    [loadingView.indicatorView startAnimating];
    if( duration > DBL_EPSILON ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if( loadingView.superview != nil ){
                [loadingView hide];
                if( timeoutBlock != nil ){
                     timeoutBlock();
                }
            }
        });
    }
    return loadingView;
}

- (void)dealloc{
    [self hide];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.contentView makeBorderCornerWithRadius:10];
    CGFloat scale = 53.0/20.0;
    self.indicatorView.transform = CGAffineTransformMakeScale(scale, scale);
}



- (void)hide{
    if( self.superview == nil ){
        return;
    }
    [self.indicatorView stopAnimating];
    [self removeFromSuperview];
}

//- (void)startTimer{
//    if( self.timer != nil ){
//        return;
//    }
//
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(onTimerEventArrived:) userInfo:nil repeats:NO];
//}
//
//- (void)stopTimer{
//    if( self.timer == nil ){
//        return;
//    }
//    [self.timer invalidate];
//    self.timer = nil;
//}
//
//- (void)onTimerEventArrived:(NSTimer *)sender{
//
//}


@end
