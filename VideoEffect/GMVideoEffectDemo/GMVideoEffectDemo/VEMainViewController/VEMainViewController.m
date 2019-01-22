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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"01_nebula.mp4" withExtension:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.playerViewController openWithPlayerItem:playerItem];
    [self.playerViewController playVideo];
}

- (IBAction)onTestButtonTouchUpInside:(id)sender{
    
    AVPlayerItem *playerItem = [[GMVideoService sharedService] test2];
    [self.playerViewController openWithPlayerItem:playerItem];
    [self.playerViewController playVideo];
}

@end
