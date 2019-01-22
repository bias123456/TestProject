//
//  UITextField+Utils.m
//  smartshop
//
//  Created by Bias.Xie on 31/05/2018.
//  Copyright © 2018 gemo. All rights reserved.
//

#import "UITextField+Utils.h"

@implementation UITextField (Utils)

- (void)setupLeftMargin:(CGFloat)leftMargin{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, self.bounds.size.height)];
    self.leftView.backgroundColor = [UIColor clearColor];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setupRightMargin:(CGFloat)rightMargin{
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightMargin, self.bounds.size.height)];
    self.rightView.backgroundColor = [UIColor clearColor];
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
