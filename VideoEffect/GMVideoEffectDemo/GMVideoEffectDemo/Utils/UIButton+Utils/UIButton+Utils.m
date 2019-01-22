//
//  UIButton+Utils.m
//  smartshop
//
//  Created by Bias.Xie on 29/05/2018.
//  Copyright © 2018 gemo. All rights reserved.
//

#import "UIButton+Utils.h"

@implementation UIButton (Utils)

- (void)setupWithTitleAtLeftStyle{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}

- (void)setupWithTitleAtBottomStyle{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//使图片和文字水平居中显示
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height ,-self.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,self.titleLabel.bounds.size.height, -self.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)setupForControlButton{
    self.backgroundColor = [UIColor yellowColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 0.5*self.layer.bounds.size.height;
    self.layer.masksToBounds = YES;
    
}

-(void)startCountDownWithSecond:(NSInteger)count{
    
    if( count <= 0 ){
        return;
    }
    
    __block NSInteger time = count - 1; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self setTitle:@"点击获取" forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
            
        }else{
            
            NSInteger seconds = time % count;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self setTitle:[NSString stringWithFormat:@"%.2ld秒", seconds] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


@end
