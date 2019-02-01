//
//  VEMainViewController.m
//  GMVideoEffectDemo
//
//  Created by BBias Xie on 2019/1/22.
//  Copyright © 2019 BBias Xie. All rights reserved.
//

#import "VEMainViewController.h"
#import "AVVideoPlayerViewController.h"
#import "Masonry/Masonry.h"
#import "GMVideoService.h"

@interface VEMainViewController ()


@property (nonatomic,readwrite,strong) AVVideoPlayerViewController *playerViewController;
@property (nonatomic,readwrite,strong) IBOutlet UIView *playerView_placeholderView;
@property (nonatomic,readwrite,strong) IBOutlet UIView *overlapView;

@end

@implementation VEMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.playerViewController = [[AVVideoPlayerViewController alloc] init];
    [self.playerView_placeholderView addSubview:self.playerViewController.view];
    [self.playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@(0));
    }];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onPlayButtonTouchUpInside:(id)sender{
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"01_nebula.mp4" withExtension:nil];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
//    [self.playerViewController openWithPlayerItem:playerItem];
//    [self.playerViewController playVideo];
    
    
    AVPlayerItem *playerItem = [[GMVideoService sharedService] makeCombinedVideo];
    
    
    AVSynchronizedLayer *overlapLayer = [[GMVideoService sharedService] createOverlapSubjectsForPlayerItem:playerItem bounds:self.overlapView.bounds];
    [self.overlapView.layer addSublayer:overlapLayer];
    //[self.overlapView.layer setNeedsDisplay];
    
    //    CGFloat scale = fminf(overlapLayer.bounds.size.width / TH720pVideoRect.size.width, overlapLayer.bounds.size.height /TH720pVideoRect.size.height);
    //    CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(overlapLayer.bounds.size, self.view.bounds);
    //    self.overlapView.center = CGPointMake( CGRectGetMidX(videoRect), CGRectGetMidY(videoRect));
    //    self.overlapView.transform = CGAffineTransformMakeScale(scale, scale);
    
    
    [self.playerViewController openWithPlayerItem:playerItem];
    [self.playerViewController playVideo];
}

- (IBAction)onExportButtonTouchUpInside:(id)sender{
    

    
    AVPlayerItem *playerItem = [[GMVideoService sharedService] makeCombinedVideo];
    
    
    AVSynchronizedLayer *overlapLayer = [[GMVideoService sharedService] createOverlapSubjectsForPlayerItem:playerItem bounds:self.overlapView.bounds];
    
    [[GMVideoService sharedService] makeExportableWithPlayerItem:playerItem titleLayer:overlapLayer viewBounds:overlapLayer.bounds];
}

@end
