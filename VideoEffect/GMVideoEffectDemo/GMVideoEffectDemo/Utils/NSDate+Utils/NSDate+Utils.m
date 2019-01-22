//
//  NSDate+Utils.m
//  ActU
//
//  Created by Bias.Xie on 2018/1/22.
//  Copyright © 2018年 Juer. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)


- (NSString *)toNumberString{
    NSTimeInterval interval = [self timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%.6f",interval];
    return [str stringByReplacingOccurrencesOfString:@"." withString:@""];
}

- (NSString *)toDateStringWithFormat:(NSString *)format{
    if( format.length == 0 ){
        format = @"yyyy-MM-dd hh:mm:ss";
    }
    static NSDateFormatter *dateFormatter = nil;
    if( dateFormatter == nil ){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = format;
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toDateString{
    static NSDateFormatter *dateFormatter = nil;
    if( dateFormatter == nil ){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMddhhmmssSSS";
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toShortDateString{
    static NSDateFormatter *dateFormatter = nil;
    if( dateFormatter == nil ){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd hh:mm";
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toDateStringYearMonthDay{
    static NSDateFormatter *dateFormatter = nil;
    if( dateFormatter == nil ){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toPresentTime {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //上次时间
    NSDate *lastDate = [self dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:self]];
    //当前时间
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:[NSDate date]]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    NSInteger month = intevalTime / 60 / 60 / 24 / 30;
    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
    
    if (minutes < 1) {
        return  @"刚刚";
    }else if (minutes >= 1 && minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
    }else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时前",(long)hours];
    }else if (day < 30){
        return [NSString stringWithFormat: @"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }else if (yers >= 1){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
}

@end
