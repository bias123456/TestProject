//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct tagTransformQuad
{
    CGPoint tl;
    CGPoint tr;
    CGPoint bl;
    CGPoint br;
}TransformQuad;

CATransform3D CATransform3DWithQuadFromRect(TransformQuad q, CGRect rect);

@interface UIImage (Utility)

+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

- (UIImage*)deepCopy;

- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;

- (UIImage*)crop:(CGRect)rect;
- (UIImage *)cropMaxImageWithSize:(CGSize)cropSize;

- (UIImage*)maskedImage:(UIImage*)maskImage;

- (UIImage*)gaussBlur:(CGFloat)blurLevel;       //  {blurLevel | 0 ≤ t ≤ 1}

//calculateFillDisplayFrame
+ (CGRect)calculateFitDisplayFrameWithImageSize:(CGSize)imageSize displayFrame:(CGRect)displayFrame;
+ (CGRect)calculateFillDisplayFrameWithImageSize:(CGSize)imageSize displayFrame:(CGRect)displayFrame;
- (CGRect)calculateFillDisplayFrameWithDisplayFrame:(CGRect)displayFrame;
- (CGRect)calculateFitDisplayFrameWithDisplayFrame:(CGRect)displayFrame;

+(UIImage *)imageFromImageBuffer:(CVImageBufferRef)imageBuffer;
//只有加入CoreGraph库时才能使用
+ (void)showInfoForPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 通过用户等级返回对应的图片
 @param grade 等级字段 0:游客，1:体验官，2:vip，3:尊享官，4:区县负责人，5:城市，6:省
 */
+ (UIImage *)imageWithGrade:(NSInteger)grade;

@end


