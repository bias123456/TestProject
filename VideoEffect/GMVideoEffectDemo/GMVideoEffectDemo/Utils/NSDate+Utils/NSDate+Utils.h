//
//  NSDate+Utils.h
//  ActU
//
//  Created by Bias.Xie on 2018/1/22.
//  Copyright © 2018年 Juer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

///数字形式的字符串(后6位为毫秒)，表示与1970年1月1日零时的时间间隔
- (NSString *)toNumberString;
///日期形式的字符串,如果format为nil或空字符串，则默认为"yyyy-MM-dd hh:mm:ss"
- (NSString *)toDateStringWithFormat:(NSString *)format;
///日期形式的字符串(yyyyMMddhhmmssSSS)，表示与1970年1月1日零时的时间间隔
- (NSString *)toDateString;
///日期形式的字符串(MM-dd hh:mm)
- (NSString *)toShortDateString;
///日期形式的字符串(yyyy-MM-dd)，表示与1970年1月1日零时的时间间隔
- (NSString*) toDateStringYearMonthDay;
//距离当前时间
- (NSString *)toPresentTime;

@end
