//
//  UIAlertController+Utils.m
//  Justice
//
//  Created by Bias.Xie on 17/9/26.
//  Copyright © 2017年 Gemo. All rights reserved.
//

#import "UIAlertController+Utils.h"


@implementation UIAlertController (Utils)

//NSString *title=NSLocalizedString(@"Objective-C", nil);
//NSString *tipContent=NSLocalizedString(@"FlyElephant", nil);
//UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:tipContent preferredStyle:UIAlertControllerStyleAlert];
//UIColor *color=[UIColor redColor];
//UIAlertAction *sureAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//}];
//[sureAction setValue:color forKey:@"titleTextColor"];
//UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//}];
//[cancelAction setValue:color forKey:@"titleTextColor"];
//[alertController addAction:sureAction];
//[alertController addAction:cancelAction];
//[self presentViewController:alertController animated:YES completion:nil];


+ (nullable instancetype)easyAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle buttonTitles:(nonnull NSArray *)buttonTitles handler:(void (^ __nullable)(UIAlertController * alertController, NSInteger buttonIndex))handler{
//    if( buttonTitles.count == 0 ){
//        return nil;
//    }
    
    //----创建alertController----//
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    for( NSInteger index = 0 ; index < buttonTitles.count ; index++ ){
        NSString *title = [buttonTitles objectAtIndex:index];
        UIAlertActionStyle style;
        if( index == 0 ){
            style = UIAlertActionStyleCancel;
        }else{
            style = UIAlertActionStyleDefault;
        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            
            if( handler==nil){
                return;
            }
            handler(alertController,index);
        }];
        [alertController addAction:action];
    }
    
    return alertController;

}

+ (nullable instancetype)easyAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void (^ __nullable)(UIAlertController * alertController,NSInteger buttonIndex))handler buttonTitles:(nonnull NSString *)cancelButtonTitle,...NS_REQUIRES_NIL_TERMINATION{
    
    NSMutableArray *buttonTitleList = nil;
    if( cancelButtonTitle != nil ){
        //----获取所有buttonTitle----//
        buttonTitleList = [[NSMutableArray alloc] init];
        va_list arg_ptr;
        NSString *nArgValue = cancelButtonTitle;
        [buttonTitleList addObject:nArgValue];
        va_start(arg_ptr,cancelButtonTitle);  //以固定参数的地址为起点确定变参的内存起始地址。
        int nArgCout = 0;
        
        while( (nArgValue = va_arg(arg_ptr, NSString *)) != nil ){
            printf("the %d th arg: %s",nArgCout,nArgValue.UTF8String); //输出各参数的值
            [buttonTitleList addObject:nArgValue];
        }
        va_end(arg_ptr);
    }
    
    return [self easyAlertControllerWithTitle:title message:message preferredStyle:preferredStyle buttonTitles:buttonTitleList handler:handler];
}

+ (void)showAlertInViewController:(UIViewController *)parentViewController withMessage:(NSString *)message{
    
    UIAlertController *ac = [UIAlertController easyAlertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert buttonTitles:@[@"确认"] handler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        
    }];
    [parentViewController presentViewController:ac animated:YES completion:nil];
}

@end
