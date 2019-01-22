//
//  NSData+Utils.m
//  EADemo
//
//  Created by Bias.Xie on 13/07/2018.
//  Copyright © 2018 DTS. All rights reserved.
//

#import "NSData+Utils.h"

@implementation NSData (Utils)

/**
 *  将二进制数据转换成十六进制字符串
 *
 *  @param data 二进制数据
 *
 *  @return 十六进制字符串
 */
+ (NSString *)data2Hex:(NSData *)data {
    if (!data) {
        return nil;
    }
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:data.length * 2];
    for (int i=0; i < data.length-1; i++){
        [str appendFormat:@"0x%02x ", bytes[i]];
    }
    [str appendFormat:@"0x%02x", bytes[data.length-1]];
    return str;
}

- (NSString *)toHexString{
    return [[self class] data2Hex:self];
}


- (NSString *)toUtf8String {
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if (string == nil) {
        string = [[NSString alloc] initWithData:[self UTF8Data] encoding:NSUTF8StringEncoding];
    }
    return string;
}

//              https://zh.wikipedia.org/wiki/UTF-8
//              https://www.w3.org/International/questions/qa-forms-utf-8
//
//            $field =~
//                    m/\A(
//            [\x09\x0A\x0D\x20-\x7E]            # ASCII
//            | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
//            |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
//            | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
//            |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
//            |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
//            | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
//            |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
//            )*\z/x;

- (NSData *)UTF8Data {
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:self.length];
    
    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
    
    uint64_t index = 0;
    const uint8_t *bytes = self.bytes;
    
    long dataLength = (long) self.length;
    
    while (index < dataLength) {
        uint8_t len = 0;
        uint8_t firstChar = bytes[index];
        
        // 1个字节
        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
            len = 1;
        }
        // 2字节
        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
            if (index + 1 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                if (0x80 <= secondChar && secondChar <= 0xBF) {
                    len = 2;
                }
            }
        }
        // 3字节
        else if ((firstChar & 0xF0) == 0xE0) {
            if (index + 2 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                
                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                }
            }
        }
        // 4字节
        else if ((firstChar & 0xF8) == 0xF0) {
            if (index + 3 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                uint8_t fourthChar = bytes[index + 3];
                
                if (firstChar == 0xF0) {
                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if (firstChar == 0xF3) {
                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                }
            }
        }
        // 5个字节
        else if ((firstChar & 0xFC) == 0xF8) {
            len = 0;
        }
        // 6个字节
        else if ((firstChar & 0xFE) == 0xFC) {
            len = 0;
        }
        
        if (len == 0) {
            index++;
            [resData appendData:replacement];
        } else {
            [resData appendBytes:bytes + index length:len];
            index += len;
        }
    }
    
    return resData;
}

//作者：andforce
//链接：https://www.jianshu.com/p/1b3cbcbd7f66
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。


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


+ (void)saveData:(NSData *)data withName:(NSString *)name{
    NSString *path = [self createUniqueFilePathWithExt:name];
    BOOL flag = [data writeToFile:path atomically:YES];
    if( flag == YES ){
        DLog(@"path=%@",path);
        DLog(@"保存成功");
    }else{
        DLog(@"保存失败");
    }
}


@end
