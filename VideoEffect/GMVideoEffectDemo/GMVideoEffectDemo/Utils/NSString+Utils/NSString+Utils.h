//
//  NSString+Utils.h
//  Inspection
//
//  Created by Bias.Xie on 17/8/17.
//  Copyright © 2017年 Gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const scInavailableId = @"-1";
static NSString * const AUAttentionTitleForAdd = @"+ 关注";
static NSString * const AUAttentionTitleForCancel = @"取消关注";

static const CGFloat kUITextViewPadding = 16.0f;

@interface NSString (Utils)

+ (NSString *)stringFromInteger:(NSInteger)value;
+ (NSString *)stringFromFloat:(CGFloat)value;
+ (NSString *)stringFromLong:(long)value;
+ (NSString *)stringFromInt:(int)value;

+ (BOOL)isMobileNumber:(NSString *)phoneNumber;
- (BOOL)isMobileNumber;

+ (NSString *)moneyFormatStringWithFloat:(CGFloat)data;
+ (NSString *)moneyFormatStringWithString:(NSString *)data;
- (NSString *)toMoneyFormatString;


+ (NSString *)encryptPhoneNumber:(NSString *)phoneNumber;
- (NSString *)toEncryptPhoneNumber;


+ (NSMutableAttributedString *)deleteLineStringWithString:(NSString *)string;
- (NSMutableAttributedString *)toDeleteLineString;

/**
 检查字符串是否匹配指定的正则表达式

 @param string 待检查的字符串
 @param regex 正则表达式
 @return 返回检查结果，YES表示匹配，NO表示不匹配
 */
+ (BOOL)isString:(NSString *)string matchRegex:(NSString *)regex;
- (BOOL)isMatchRegex:(NSString *)regex;

+ (BOOL)isInavailableId:(NSString *)str;
- (BOOL)isRemotePath;
- (BOOL)isLocalPath;
- (NSURL *)toUrl;
- (NSString *)toYearMonthDayPart;

- (NSString *)stringByAddIntegerValue:(NSInteger)value;
- (NSString *)stringByAddFloatValue:(float)value;

+ (NSString *)createUniqueFilePathWithExt:(NSString *)ext;
+ (NSString *)createUniqueFilePathVideo;
+ (NSString *)createUniqueFilePathAudio;

+ (NSString *)replaceUnicode:(NSString*)TransformUnicodeString;

/**
 获取字符串链接中的第一个链接,默认给一个本地图片链接

 @param string 拼接的字符串
 @return 返回URL字符串
 */
+ (NSString *)getFirstImageUrlFromTotalString:(NSString *)string;


+ (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


+ (NSString *)twoDecimalPlacesReservedWithString:(NSString *)src;
- (NSString *)toTwoDecimalPlacesReserved;


+ (NSString *)base64_encode:(NSString *)string;
+ (NSString *)base64_dencode:(NSString *)base64String;

@end
