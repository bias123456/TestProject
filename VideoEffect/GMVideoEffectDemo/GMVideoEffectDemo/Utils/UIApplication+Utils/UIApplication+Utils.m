//
//  UIApplication+Utils.m
//  smartshop
//
//  Created by Bias.Xie on 25/05/2018.
//  Copyright © 2018 gemo. All rights reserved.
//

#import "UIApplication+Utils.h"

@implementation UIApplication (Utils)

- (void)reconstructRootViewControllerWithViewController:(UIViewController *)newRootViewController{
    
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:newRootViewController];
    rootViewController.navigationBarHidden = YES;
    self.delegate.window.rootViewController = rootViewController;
    
}

@end
