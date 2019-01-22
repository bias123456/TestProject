//
//  NSData+Utils.h
//  EADemo
//
//  Created by Bias.Xie on 13/07/2018.
//  Copyright © 2018 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utils)

- (NSString *)toHexString;
- (NSString *)toUtf8String;
+ (void)saveData:(NSData *)data withName:(NSString *)name;

@end
