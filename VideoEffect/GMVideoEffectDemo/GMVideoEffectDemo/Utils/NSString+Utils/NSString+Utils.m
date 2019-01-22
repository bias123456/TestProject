//
//  NSString+Utils.m
//  Inspection
//
//  Created by Bias.Xie on 17/8/17.
//  Copyright © 2017年 Gemo. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (BOOL)isInavailableId:(NSString *)str{
    if( str.length == 0 ){
        return YES;
    }
    return NO;
}


+ (NSString *)stringFromInteger:(NSInteger)value{
    return [self stringWithFormat:@"%ld",value];
}

+ (NSString *)stringFromFloat:(CGFloat)value{
    return [self stringWithFormat:@"%f",value];
}

+ (NSString *)stringFromLong:(long)value{
    return [self stringWithFormat:@"%ld",value];
}

+ (NSString *)stringFromInt:(int)value{
    return [self stringWithFormat:@"%d",value];
}



- (NSString *)stringByAddIntegerValue:(NSInteger)value{
    return [NSString stringWithFormat:@"%ld",self.integerValue + value];
}

- (NSString *)stringByAddFloatValue:(float)value{
        return [NSString stringWithFormat:@"%f",self.floatValue + value];
}


+ (BOOL)isMobileNumber:(NSString *)phoneNumber{
    
    NSString *MOBILE = @"^((17[0-9])|(13[0-9])|(14[0-9])|(15([0-9]))|(18[0-9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:phoneNumber];
}

- (BOOL)isMobileNumber{
    return [[self class] isMobileNumber:self];
}

+ (BOOL)isString:(NSString *)string matchRegex:(NSString *)regex{
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexPredicate evaluateWithObject:string];
}

- (BOOL)isMatchRegex:(NSString *)regex{
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexPredicate evaluateWithObject:self];
}


+ (NSString *)moneyFormatStringWithFloat:(CGFloat)data{
    return [NSString stringWithFormat:@"¥%0.02f",data];
}

+ (NSString *)moneyFormatStringWithString:(NSString *)data{
    CGFloat value = data.floatValue;
    return [self moneyFormatStringWithFloat:value];
}

+ (NSMutableAttributedString *)deleteLineStringWithString:(NSString *)string{
    //获取字符串的长度
    NSUInteger length = [string length];
    
    //从这里开始就是设置富文本的属性
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    
    //下面开始是设置线条的风格：
    //第一个参数addAttribute:是设置要中线（删除线）还是下划线。
    //NSStrikethroughStyleAttributeName：这种是从文本中间穿过，也就是删除线。
    //NSUnderlineStyleAttributeName：这种是下划线。
    
    //第二个参数value：是设置线条的风格：虚线，实现，点线......
    //第二参数需要同时设置Pattern和style才能让线条显示。
    
    //第三个参数range:是设置线条的长度，切记，不能超过字符串的长度，否则会报错。
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)  range:NSMakeRange(0, length)];
    
    //下列是设置线条的颜色
    //第一个参数就是选择设置中线的颜色还是下划线的颜色，如果上面选择的是中线，这里就要选择中线，否则颜色设置不上去。
    //第二个参数很简单，就是颜色而已。
    //第三个参数：同上。
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, length)];
    
    return attri;
    
}

- (NSMutableAttributedString *)toDeleteLineString{
    return [[self class] deleteLineStringWithString:self];
}

- (NSString *)toMoneyFormatString{
    return [[self class] moneyFormatStringWithString:self];
}


- (BOOL)isRemotePath{
    
    return [self containsString:@"http://"]||[self containsString:@"https://"];
}

- (BOOL)isLocalPath{
    return [self containsString:@"file:///"];
}

- (NSURL *)toUrl{
    NSURL *url;
    if( self.isRemotePath || self.isLocalPath ){
        url = [NSURL URLWithString:self];
    }else{
        url = [NSURL fileURLWithPath:self];
    }
    return url;
}

- (NSString *)toYearMonthDayPart{
    NSArray *components = [self componentsSeparatedByString:@" "];
    return components.firstObject;
}

+ (NSString *)encryptPhoneNumber:(NSString *)phoneNumber{
    NSRange range;
    range.location = 3;
    range.length = 4;
    NSString *encryptPhoneNumber = [phoneNumber stringByReplacingCharactersInRange:range withString:@"****"];
    return encryptPhoneNumber;
}

- (NSString *)toEncryptPhoneNumber{
    return [[self class] encryptPhoneNumber:self];
}

+ (NSString *)createUniqueFilePathVideo{
    return [self createUniqueFilePathWithExt:@"mp4"];
}

+ (NSString *)createUniqueFilePathAudio{
    return [self createUniqueFilePathWithExt:@"caf"];
}

+ (NSString *)createUniqueFilePathWithExt:(NSString *)ext{
    static long size = 0;
    size ++ ;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *docDir = [paths objectAtIndex:0];
    NSString *docDir = NSTemporaryDirectory();
    NSString *album = [docDir stringByAppendingPathComponent:@"album"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:album]) {
        NSLog(@"first run");
        [[NSFileManager defaultManager] createDirectoryAtPath:album withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",album);
    }
    double timenumber = [NSDate date].timeIntervalSince1970;
    NSLog(@"timenumber %lf",timenumber);
    NSString *time = [NSString stringWithFormat:@"%lf",timenumber];
    time = [time stringByReplacingOccurrencesOfString:@"." withString:@"mm"];
    NSLog(@"%@",time);
    NSString *videoString = [NSString stringWithFormat:@"%@number%08ld.%@",time,size,ext];
    NSString *path = [NSString stringWithFormat:@"%@/%@",album,videoString];
    NSLog(@"path %@",path);
    return path;
}

/*  城市选择器转码
 转码为中文
 @param TransformUnicodeString 转码前
 @return 转码后
 */
+ (NSString*)replaceUnicode:(NSString*)TransformUnicodeString {
    NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString*tepStr3 = [[@"\""  stringByAppendingString:tepStr2] stringByAppendingString:@"\""];
    NSData*tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
    NSString*axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
    
    return  [axiba stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSString *)getFirstImageUrlFromTotalString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@";"];
    NSString *imageUrl;
    if (array.count) {
        imageUrl = array[0];
    }
    return imageUrl;
}

+ (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string{
    
    NSDictionary *attrs = @{NSFontAttributeName:font};
    
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    return [[self class] sizeWithFont:font maxSize:maxSize string:self];
}


+ (NSString *)twoDecimalPlacesReservedWithString:(NSString *)src{
    CGFloat fl = src.floatValue;
    NSString *res = [NSString stringWithFormat:@"%0.2f",fl];
    return res;
}

- (NSString *)toTwoDecimalPlacesReserved{
    return [[self class] twoDecimalPlacesReservedWithString:self];
}


+ (NSString *)base64_encode:(NSString *)string
{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}

+ (NSString *)base64_dencode:(NSString *)base64String
{
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}





@end
