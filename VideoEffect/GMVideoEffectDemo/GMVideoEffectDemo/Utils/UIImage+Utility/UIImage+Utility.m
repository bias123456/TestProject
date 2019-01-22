//
//  UIImage+Utility.m
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "UIImage+Utility.h"
//#import "Definitions.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Utility)

+ (UIImage*)decode:(UIImage*)image
{
    if(image==nil){  return nil; }
    
    UIGraphicsBeginImageContext(image.size);
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)fastImageWithData:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    return [self decode:image];
}

+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [self decode:image];
}

#pragma mark- Copy

- (UIImage*)deepCopy
{
    return [UIImage decode:self];
}

#pragma mark- Resizing

- (UIImage*)resize:(CGSize)size
{
    int W = size.width;
    int H = size.height;
    
    CGImageRef   imageRef   = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W = size.height;
        H = size.width;
    }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, W, H), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

- (UIImage*)aspectFit:(CGSize)size
{
    CGFloat ratio = MIN(size.width/self.size.width, size.height/self.size.height);
    return [self resize:CGSizeMake(self.size.width*ratio, self.size.height*ratio)];
}

- (UIImage*)aspectFill:(CGSize)size
{
    return [self aspectFill:size offset:0];
}

- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset
{
    int W  = size.width;
    int H  = size.height;
    int W0 = self.size.width;
    int H0 = self.size.height;
    
    CGImageRef   imageRef = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W  = size.height;
        H  = size.width;
        W0 = self.size.height;
        H0 = self.size.width;
    }
    
    double ratio = MAX(W/(double)W0, H/(double)H0);
    W0 = ratio * W0;
    H0 = ratio * H0;
    
    int dW = abs((W0-W)/2);
    int dH = abs((H0-H)/2);
    
    if(dW==0){ dH += offset; }
    if(dH==0){ dW += offset; }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(-dW, -dH, W0, H0), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

#pragma mark- Clipping

- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)cropMaxImageWithSize:(CGSize)cropSize
{

    CGRect cropPosition;
    cropPosition.size = cropSize;
    
    if( cropPosition.size.width > self.size.width )
    {
        cropPosition.size.width = self.size.width;
        cropPosition.size.height = cropPosition.size.width * self.size.height/self.size.width;
    }
    if( cropPosition.size.height > self.size.height )
    {
        cropPosition.size.height = self.size.height;
        cropPosition.size.width = cropPosition.size.height * self.size.width / self.size.height;
    }
    cropPosition.origin.x = 0.5 * ( self.size.width - cropPosition.size.width );
    cropPosition.origin.y = 0.5 * ( self.size.height - cropPosition.size.height );
    return [self crop:cropPosition];
}

#pragma mark- Masking

- (UIImage*)maskedImage:(UIImage*)maskImage
{
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage.CGImage),
                                        CGImageGetHeight(maskImage.CGImage),
                                        CGImageGetBitsPerComponent(maskImage.CGImage),
                                        CGImageGetBitsPerPixel(maskImage.CGImage),
                                        CGImageGetBytesPerRow(maskImage.CGImage),
                                        CGImageGetDataProvider(maskImage.CGImage), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(self.CGImage, mask);
    
    UIImage *result = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(mask);
    CGImageRelease(masked);
    
    return result;
}

#pragma mark- Blur

- (UIImage*)gaussBlur:(CGFloat)blurLevel
{
    blurLevel = MIN(1.0, MAX(0.0, blurLevel));
    
    int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    if( error )
    {
        
    }
    error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    if( error )
    {
        
    }
    outBuffer = inBuffer;
    
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    free( kernel );
    return returnImage;
}


//calculateFillDisplayFrame

+ (CGRect)calculateFitDisplayFrameWithImageSize:(CGSize)imageSize displayFrame:(CGRect)displayFrame
{
    CGRect fitDisplayFrame;
    double scaleW = imageSize.width / displayFrame.size.width;
    double scaleH = imageSize.height / displayFrame.size.height;
    if( scaleW < scaleH )
    {
        fitDisplayFrame.size.height = displayFrame.size.height;
        fitDisplayFrame.size.width = imageSize.width * fitDisplayFrame.size.height / imageSize.height;
        fitDisplayFrame.origin.y = 0;
        fitDisplayFrame.origin.x = 0.5 * (displayFrame.size.width-fitDisplayFrame.size.width);
    }
    else if(scaleW > scaleH )
    {
        fitDisplayFrame.size.width = displayFrame.size.width;
        fitDisplayFrame.size.height = imageSize.height * fitDisplayFrame.size.width/imageSize.width;
        fitDisplayFrame.origin.x = 0;
        fitDisplayFrame.origin.y = 0.5 * ( displayFrame.size.height-fitDisplayFrame.size.height);
    }
    else
    {
        fitDisplayFrame = displayFrame;
    }
    return fitDisplayFrame;
}


+ (CGRect)calculateFillDisplayFrameWithImageSize:(CGSize)imageSize displayFrame:(CGRect)displayFrame
{
    CGRect fillDisplayFrame;
    double scaleW = imageSize.width / displayFrame.size.width;
    double scaleH = imageSize.height / displayFrame.size.height;
    if( scaleW > scaleH )
    {
        fillDisplayFrame.size.height = displayFrame.size.height;
        fillDisplayFrame.size.width = imageSize.width * fillDisplayFrame.size.height / imageSize.height;
        fillDisplayFrame.origin.y = 0;
        fillDisplayFrame.origin.x = 0.5 * (displayFrame.size.width-fillDisplayFrame.size.width);
    }
    else if(scaleW < scaleH )
    {
        fillDisplayFrame.size.width = displayFrame.size.width;
        fillDisplayFrame.size.height = imageSize.height * fillDisplayFrame.size.width/imageSize.width;
        fillDisplayFrame.origin.x = 0;
        fillDisplayFrame.origin.y = 0.5 * ( displayFrame.size.height-fillDisplayFrame.size.height);
    }
    else
    {
        fillDisplayFrame = displayFrame;
    }
    return fillDisplayFrame;
}

- (CGRect)calculateFillDisplayFrameWithDisplayFrame:(CGRect)displayFrame
{
    return [UIImage calculateFillDisplayFrameWithImageSize:self.size displayFrame:displayFrame];
}

- (CGRect)calculateFitDisplayFrameWithDisplayFrame:(CGRect)displayFrame
{
    return [UIImage calculateFitDisplayFrameWithImageSize:self.size displayFrame:displayFrame];
}



CATransform3D CATransform3DWithQuadFromRect(TransformQuad q, CGRect rect)
{
    double X = rect.origin.x;
    double Y = rect.origin.y;
    double W = rect.size.width;
    double H = rect.size.height;
    
    double x1a = q.tl.x;
    double y1a = q.tl.y;
    
    double x2a = q.tr.x;
    double y2a = q.tr.y;
    
    double x3a = q.bl.x;
    double y3a = q.bl.y;
    
    double x4a = q.br.x;
    double y4a = q.br.y;
    
    double y21 = y2a - y1a;
    double y32 = y3a - y2a;
    double y43 = y4a - y3a;
    double y14 = y1a - y4a;
    double y31 = y3a - y1a;
    double y42 = y4a - y2a;
    
    double a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    double b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    double c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    
    double d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    double e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    double f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));
    
    double g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    double h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    double i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    const double kEpsilon = 0.0001;
    
    if(fabs(i) < kEpsilon)
    {
        i = kEpsilon* (i > 0 ? 1.0 : -1.0);
    }
    
    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};
    
    return transform;
}



+(UIImage *)imageFromImageBuffer:(CVImageBufferRef)imageBuffer
{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(imageBuffer),
                                                 CVPixelBufferGetHeight(imageBuffer))];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    //[self doSomethingWithOurUIImage:image];
    CGImageRelease(videoImage);
    
    return image;
}

/// 0:游客，1:体验官，2:vip，3:尊享官，4:区县负责人，5:城市，6:省
+ (UIImage *)imageWithGrade:(NSInteger)grade {
    if (grade == 0) {
        return [UIImage imageNamed:@"img_visitor"];
    } else if (grade == 1) {
        return [UIImage imageNamed:@"img_visitor"];
    } else if (grade == 2) {
        return [UIImage imageNamed:@"img_vipp"];
    } else if (grade == 3) {
        return [UIImage imageNamed:@"img_vipp"];
    } else if (grade == 4) {
        return [UIImage imageNamed:@"img_vipp"];
    } else if (grade == 5) {
        return [UIImage imageNamed:@"img_vipp"];
    } else if (grade == 6) {
        return [UIImage imageNamed:@"img_vipp"];
    } else {
        return [UIImage imageNamed:@"img_vipp"];
    }
}

+ (void)showInfoForPixelBuffer:(CVPixelBufferRef)pixelBuffer{
//    DLog(@"-----infor start for pixelBuffer %p----", pixelBuffer );
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    size_t width = CVPixelBufferGetWidth(pixelBuffer);
//    DLog(@"width=%ld",width);
//    size_t height = CVPixelBufferGetHeight(pixelBuffer);
//    DLog(@"height=%ld",height);
//    CFTypeID typeId = CVPixelBufferGetTypeID();
//    DLog(@"typeId=%ld",typeId);
//    size_t dataSize = CVPixelBufferGetDataSize(pixelBuffer);
//    DLog(@"dataSize=%ld",dataSize);
//    IOSurfaceRef ioSurface = CVPixelBufferGetIOSurface(pixelBuffer);
//    DLog(@"ioSurface=%p",ioSurface);
//    void *baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
//    DLog(@"baseAddress=%p",baseAddress);
//    
//    size_t planeCount =  CVPixelBufferGetPlaneCount(pixelBuffer);
//    DLog(@"planeCount=%ld",planeCount);
//    for( size_t planeIndex = 0 ; planeIndex < planeCount ; planeIndex ++ ){
//        size_t widthOfPlane = CVPixelBufferGetWidthOfPlane(pixelBuffer, planeIndex);
//        DLog(@"planeIndex = %ld , widthOfPlane=%ld",planeIndex,widthOfPlane);
//        size_t heightOfPlane = CVPixelBufferGetHeightOfPlane(pixelBuffer, planeIndex);
//        DLog(@"planeIndex = %ld , heightOfPlane=%ld",planeIndex,heightOfPlane);
//        void *baseAddressOfPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, planeIndex);
//        DLog(@"planeIndex = %ld , baseAddressOfPlane=%p",planeIndex,baseAddressOfPlane);
//    }
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    DLog(@"-----infor end for pixelBuffer %p----", pixelBuffer );
}


@end



//http://blog.csdn.net/jeffasd/article/details/78181856?locationNum=1&fps=1
//
//  ViewController.m
//  test_image_covert_data_01
//
//  Created by jeffasd on 2016/9/30.
//  Copyright © 2016年 jeffasd. All rights reserved.
//

//#import "ViewController.h"
//
//#define RETAINED_BUFFER_COUNT 4
//
//@interface ViewController ()
//
//@property (nonatomic, assign) CVPixelBufferPoolRef pixelBufferPool;
//
//@end
//
//@implementation ViewController
//
//#pragma CVPixelBufferRef与UIImage的互相转换
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.pixelBufferPool = NULL;
//    
//    UIImage *image = [UIImage imageNamed:@"atlastest"];
//    CVPixelBufferRef pixelBuffer = [self CVPixelBufferRefFromUiImage:image];
//    //CVPixelBufferRef pixelBuffer = [self pixelBufferFasterFromImage:image];
//    //CVPixelBufferRef pixelBuffer = [[self class] pixelBufferFromCGImage:image.CGImage];
//    //UIImage *covertImage = [[self class] imageFromCVPixelBufferRef0:pixelBuffer];
//    //UIImage *covertImage = [[self class] imageFromCVPixelBufferRef1:pixelBuffer];
//    //UIImage *covertImage = [[self class] imageFromCVPixelBufferRef2:pixelBuffer];
//    //    covertImage = nil;
//    //
//    UIImage *decodeImage = [[self class] decodeImageWithImage:image];
//    decodeImage = nil;
//    
//    CVPixelBufferRef pixelBuffer1 = [self pixelBufferFromImageWithPool:NULL image:image];
//    pixelBuffer1 = nil;
//    
//    //covertImage = nil;
//}
//
//static OSType inputPixelFormat(){
//    //注意CVPixelBufferCreate函数不支持 kCVPixelFormatType_32RGBA 等格式 不知道为什么。
//    //支持kCVPixelFormatType_32ARGB和kCVPixelFormatType_32BGRA等 iPhone为小端对齐因此kCVPixelFormatType_32ARGB和kCVPixelFormatType_32BGRA都需要和kCGBitmapByteOrder32Little配合使用
//    //注意当inputPixelFormat为kCVPixelFormatType_32BGRA时bitmapInfo不能是kCGImageAlphaNone，kCGImageAlphaLast，kCGImageAlphaFirst，kCGImageAlphaOnly。
//    //注意iPhone的大小端对齐方式为小段对齐 可以使用宏 kCGBitmapByteOrder32Host 来解决大小端对齐 大小端对齐必须设置为kCGBitmapByteOrder32Little。
//    //return kCVPixelFormatType_32RGBA;//iPhone不支持此输入格式!!!
//    return kCVPixelFormatType_32BGRA;
//    //return kCVPixelFormatType_32ARGB;
//}
//
//static uint32_t bitmapInfoWithPixelFormatType(OSType inputPixelFormat){
//    /*
//     CGBitmapInfo的设置
//     uint32_t bitmapInfo = CGImageAlphaInfo | CGBitmapInfo;
//     
//     当inputPixelFormat=kCVPixelFormatType_32BGRA CGBitmapInfo的正确的设置 只有如下两种正确设置
//     uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
//     uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
//     
//     typedef CF_ENUM(uint32_t, CGImageAlphaInfo) {
//     kCGImageAlphaNone,                For example, RGB.
//     kCGImageAlphaPremultipliedLast,   For example, premultiplied RGBA
//     kCGImageAlphaPremultipliedFirst,  For example, premultiplied ARGB
//     kCGImageAlphaLast,                For example, non-premultiplied RGBA
//     kCGImageAlphaFirst,               For example, non-premultiplied ARGB
//     kCGImageAlphaNoneSkipLast,        For example, RBGX.
//     kCGImageAlphaNoneSkipFirst,       For example, XRGB.
//     kCGImageAlphaOnly                 No color data, alpha data only
//     };
//     
//     当inputPixelFormat=kCVPixelFormatType_32ARGB CGBitmapInfo的正确的设置 只有如下两种正确设置
//     uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
//     uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big;
//     */
//    if (inputPixelFormat == kCVPixelFormatType_32BGRA) {
//        //uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
//        //此格式也可以
//        uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
//        return bitmapInfo;
//    }else if (inputPixelFormat == kCVPixelFormatType_32ARGB){
//        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
//        //此格式也可以
//        //uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big;
//        return bitmapInfo;
//    }else{
//        DLog(@"不支持此格式");
//        return 0;
//    }
//}
//
//static CVPixelBufferPoolRef createPixelBufferPoolInner( int32_t width, int32_t height, OSType pixelFormat, int32_t maxBufferCount )
//{
//    CVPixelBufferPoolRef outputPool = NULL;
//    
//    NSDictionary *sourcePixelBufferOptions = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(pixelFormat),
//                                                (id)kCVPixelBufferWidthKey : @(width),
//                                                (id)kCVPixelBufferHeightKey : @(height),
//                                                //(id)kCVPixelFormatOpenGLESCompatibility : @(YES),
//                                                (id)kCVPixelBufferIOSurfacePropertiesKey : @{ /*empty dictionary*/ } };
//    
//    NSDictionary *pixelBufferPoolOptions = @{ (id)kCVPixelBufferPoolMinimumBufferCountKey : @(maxBufferCount) };
//    
//    CVPixelBufferPoolCreate( kCFAllocatorDefault, (__bridge CFDictionaryRef)pixelBufferPoolOptions, (__bridge CFDictionaryRef)sourcePixelBufferOptions, &outputPool );
//    
//    return outputPool;
//}
//
//static CVPixelBufferPoolRef createCVPixelBufferPoolRef(int32_t imageWidth, int32_t imageHeight){
//    OSType pixelFormat = inputPixelFormat();
//    int32_t maxRetainedBufferCount = RETAINED_BUFFER_COUNT;
//    CVPixelBufferPoolRef bufferPool = createPixelBufferPoolInner( imageWidth, imageHeight, pixelFormat, maxRetainedBufferCount );
//    if ( ! bufferPool ) {
//        DLog( @"Problem initializing a buffer pool." );
//    }
//    DLog( @"success initializing a buffer pool." );
//    return bufferPool;
//}
//
//- (CVPixelBufferRef)pixelBufferFromImageWithPool:(CVPixelBufferPoolRef)pixelBufferPool image:(UIImage *)image
//{
//    CVPixelBufferRef pxbuffer = NULL;
//    
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
//                             nil nil];
//    
//    size_t width =  CGImageGetWidth(image.CGImage);
//    size_t height = CGImageGetHeight(image.CGImage);
//    size_t bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
//#if 0
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image.CGImage);
//#endif
//    voidvoid *pxdata = NULL;
//    
//    if (pixelBufferPool == NULL){
//        DLog(@"pixelBufferPool is null!");
//        CVPixelBufferPoolRef bufferPool = createCVPixelBufferPoolRef((int32_t)width, (int32_t)height);
//        self.pixelBufferPool = bufferPool;
//        pixelBufferPool = bufferPool;
//    }
//    
//    CVReturn status = CVPixelBufferPoolCreatePixelBuffer (NULL, pixelBufferPool, &pxbuffer);
//    if (pxbuffer == NULL) {
//        status = CVPixelBufferCreate(kCFAllocatorDefault, width,
//                                     height, inputPixelFormat(), (__bridge CFDictionaryRef) options,
//                                     &pxbuffer);
//    }
//    
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    NSParameterAssert(pxdata != NULL);
//    
//#if 1 - 此去掉alpha通道效率更高
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
//    
//    //对于生成CVPixelBufferRef无法使用此方法但是对于解码图片可以使用此方法
//    //    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image.CGImage);
//    //    if (alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaOnly) {
//    //        alphaInfo = kCGImageAlphaNoneSkipFirst;
//    //    } else if (alphaInfo == kCGImageAlphaFirst) {
//    //        alphaInfo = kCGImageAlphaPremultipliedFirst;
//    //    } else if (alphaInfo == kCGImageAlphaLast) {
//    //        alphaInfo = kCGImageAlphaPremultipliedLast;
//    //    }
//    //    bitmapInfo |= alphaInfo;
//    
//    bitmapInfo = bitmapInfoWithPixelFormatType(inputPixelFormat());
//    
//    size_t bitsPerComponent = CGImageGetBitsPerComponent(image.CGImage);
//    
//    CGContextRef context = CGBitmapContextCreate(pxdata, width,
//                                                 height,bitsPerComponent,bytesPerRow, rgbColorSpace,
//                                                 bitmapInfo);
//    NSParameterAssert(context);
//    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
//    CGContextDrawImage(context, CGRectMake(0, 0, width,height), image.CGImage);
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//#else //- 此方法获取的图片可能无法还原真实的图片
//    CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
//    GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
//#if 0
//    CFIndex length = CFDataGetLength(dataFromImageDataProvider);
//    memcpy(pxdata,imageData,length);
//#else
//    CVPixelBufferCreateWithBytes(kCFAllocatorDefault,width,height,inputPixelFormat(),imageData,bytesPerRow,NULL,NULL,(__bridge CFDictionaryRef)options,&pxbuffer);
//#endif
//    CFRelease(dataFromImageDataProvider);
//#endif
//    
//    return pxbuffer;
//}
//
///** UIImage covert to CVPixelBufferRef */
////方法1 此方法能还原真实的图片
//- (CVPixelBufferRef)CVPixelBufferRefFromUiImage:(UIImage *)img {
//    CGSize size = img.size;
//    CGImageRef image = [img CGImage];
//    
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil nil];
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, inputPixelFormat(), (__bridge CFDictionaryRef) options, &pxbuffer);
//    
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//    
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    voidvoid *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    NSParameterAssert(pxdata != NULL);
//    
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    //CGBitmapInfo的设置
//    //uint32_t bitmapInfo = CGImageAlphaInfo | CGBitmapInfo;
//    
//    //当inputPixelFormat=kCVPixelFormatType_32BGRA CGBitmapInfo的正确的设置
//    //uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
//    //uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
//    
//    //当inputPixelFormat=kCVPixelFormatType_32ARGB CGBitmapInfo的正确的设置
//    //uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
//    //uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big;
//    
//    uint32_t bitmapInfo = bitmapInfoWithPixelFormatType(inputPixelFormat());
//    
//    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, bitmapInfo);
//    NSParameterAssert(context);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//    
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//    
//    return pxbuffer;
//}
//
///** UIImage covert to CVPixelBufferRef */
////方法2 注意此方法在处理某些图片时可能无法还原真实的图片
//- (CVPixelBufferRef)pixelBufferFasterFromImage:(UIImage *)image{
//    
//    CVPixelBufferRef pxbuffer = NULL;
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
//                             nil nil];
//    
//    size_t width =  CGImageGetWidth(image.CGImage);
//    size_t height = CGImageGetHeight(image.CGImage);
//    size_t bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
//    
//    CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
//    GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
//    
//    //kCGImageAlphaNoneSkipLast,       /* For example, RBGX. */
//    
//    CGColorSpaceRef colorspace = CGImageGetColorSpace(image.CGImage);
//    CGImageAlphaInfo alphainfo = CGImageGetAlphaInfo(image.CGImage);
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image.CGImage);
//    const CGFloat *decode = CGImageGetDecode(image.CGImage);
//    NSString *str = CGImageGetUTType(image.CGImage);
//    
//    //    kCVPixelFormatType_32ARGB         = 0x00000020, /* 32 bit ARGB */
//    //    kCVPixelFormatType_32BGRA         = 'BGRA',     /* 32 bit BGRA */
//    //    kCVPixelFormatType_32ABGR         = 'ABGR',     /* 32 bit ABGR */不能使用
//    //    kCVPixelFormatType_32RGBA         = 'RGBA',     /* 32 bit RGBA */不能使用
//    
//    //CVPixelBufferCreateWithBytes这里是很耗时的，要重新创建。
//    //此方法获取的CVPixelBufferRef不一定正确 如原始图片的CGImageAlphaInfo为kCGImageAlphaNoneSkipLast由于pixelFormatType没有RBGX类型的格式就没法还原原始的图片。
//    CVPixelBufferCreateWithBytes(kCFAllocatorDefault,width,height,kCVPixelFormatType_32BGRA,imageData,bytesPerRow,NULL,NULL,(__bridge CFDictionaryRef)options,&pxbuffer);
//    CFRelease(dataFromImageDataProvider);
//    CVPixelBufferRetain(pxbuffer);
//    
//    return pxbuffer;
//}
//
//+ (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
//{
//    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
//                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
//                             nil nil];
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
//                                          frameSize.height,  kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef) options,
//                                          &pxbuffer);
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    voidvoid *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
//                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
//                                           CGImageGetHeight(image)), image);//这个站CPU 相当高
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//    return pxbuffer;
//}
//
////CVPixelBufferRef 是 CMSampleBufferRef 解码后的数据
//
///** UIImage covert to CMSampleBufferRef */
//
///** CVPixelBufferRef covert to UIImage */
//+ (UIImage *)imageFromCVPixelBufferRef0:(CVPixelBufferRef)pixelBuffer{
//    // MUST READ-WRITE LOCK THE PIXEL BUFFER!!!!
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//    CGImageRef videoImage = [temporaryContext
//                             createCGImage:ciImage
//                             fromRect:CGRectMake(0, 0,
//                                                 CVPixelBufferGetWidth(pixelBuffer),
//                                                 CVPixelBufferGetHeight(pixelBuffer))];
//    
//    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
//    CGImageRelease(videoImage);
//    CVPixelBufferRelease(pixelBuffer);
//    return uiImage;
//}
//
//static OSStatus CreateCGImageFromCVPixelBuffer(CVPixelBufferRef pixelBuffer, CGImageRef *imageOut)
//{
//    OSStatus err = noErr;
//    OSType sourcePixelFormat;
//    size_t width, height, sourceRowBytes;
//    voidvoid *sourceBaseAddr = NULL;
//    CGBitmapInfo bitmapInfo;
//    CGColorSpaceRef colorspace = NULL;
//    CGDataProviderRef provider = NULL;
//    CGImageRef image = NULL;
//    sourcePixelFormat = CVPixelBufferGetPixelFormatType( pixelBuffer );
//    if ( kCVPixelFormatType_32ARGB == sourcePixelFormat )
//        bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipFirst;
//    else if ( kCVPixelFormatType_32BGRA == sourcePixelFormat )
//        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
//    else
//        return -95014; // only uncompressed pixel formats
//    sourceRowBytes = CVPixelBufferGetBytesPerRow( pixelBuffer );
//    width = CVPixelBufferGetWidth( pixelBuffer );
//    height = CVPixelBufferGetHeight( pixelBuffer );
//    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
//    sourceBaseAddr = CVPixelBufferGetBaseAddress( pixelBuffer );
//    colorspace = CGColorSpaceCreateDeviceRGB();
//    CVPixelBufferRetain( pixelBuffer );
//    provider = CGDataProviderCreateWithData( (voidvoid *)pixelBuffer, sourceBaseAddr, sourceRowBytes * height, ReleaseCVPixelBuffer);
//    image = CGImageCreate(width, height, 8, 32, sourceRowBytes, colorspace, bitmapInfo, provider, NULL, true, kCGRenderingIntentDefault);
//    if ( err && image ) {
//        CGImageRelease( image );
//        image = NULL;
//    }
//    if ( provider ) CGDataProviderRelease( provider );
//    if ( colorspace ) CGColorSpaceRelease( colorspace );
//    *imageOut = image;
//    return err;
//}
//
//static void ReleaseCVPixelBuffer(voidvoid *pixel, const voidvoid *data, size_t size)
//{
//    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)pixel;
//    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
//    CVPixelBufferRelease( pixelBuffer );
//}
//
//+(UIImage *)imageFromCVPixelBufferRef1:(CVPixelBufferRef)pixelBuffer{
//    UIImage *image;
//    @autoreleasepool {
//        CGImageRef cgImage = NULL;
//        CVPixelBufferRef pb = (CVPixelBufferRef)pixelBuffer;
//        CVPixelBufferLockBaseAddress(pb, kCVPixelBufferLock_ReadOnly);
//        OSStatus res = CreateCGImageFromCVPixelBuffer(pb,&cgImage);
//        if (res == noErr){
//            image= [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
//        }
//        CVPixelBufferUnlockBaseAddress(pb, kCVPixelBufferLock_ReadOnly);
//        CGImageRelease(cgImage);
//    }
//    return image;
//}
////第二种
//+(UIImage *)imageFromCVPixelBufferRef2:(CVPixelBufferRef)pixelBuffer{
//    CVPixelBufferRef pb = (CVPixelBufferRef)pixelBuffer;
//    CVPixelBufferLockBaseAddress(pb, kCVPixelBufferLock_ReadOnly);
//    int w = CVPixelBufferGetWidth(pb);
//    int h = CVPixelBufferGetHeight(pb);
//    int r = CVPixelBufferGetBytesPerRow(pb);
//    int bytesPerPixel = r/w;
//    unsigned charchar *buffer = CVPixelBufferGetBaseAddress(pb);
//    UIGraphicsBeginImageContext(CGSizeMake(w, h));
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    unsigned charchar *data = CGBitmapContextGetData(c);
//    if (data != NULL) {
//        int maxY = h;
//        for(int y = 0; y<maxY; y++) {
//            for(int x = 0; x<w; x++) {
//                int offset = bytesPerPixel*((w*y)+x);
//                data[offset] = buffer[offset];     // R
//                data[offset+1] = buffer[offset+1]; // G
//                data[offset+2] = buffer[offset+2]; // B
//                data[offset+3] = buffer[offset+3]; // A
//            }
//        }
//    }
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    CVPixelBufferUnlockBaseAddress(pb, kCVPixelBufferLock_ReadOnly);
//    return img;
//}
//
///** CMSampleBufferRef covert to UIImage */
//
///** CMSampleBufferRef covert to CVPixelBufferRef */
//
///** decode compress image to bitmap iamge */
//+ (UIImage *)decodeImageWithImage:(UIImage *)imageToPredraw
//{
//    // Always use a device RGB color space for simplicity and predictability what will be going on.
//    CGColorSpaceRef colorSpaceDeviceRGBRef = CGColorSpaceCreateDeviceRGB();
//    // Early return on failure!
//    if (!colorSpaceDeviceRGBRef) {
//        DLog(@"Failed to `CGColorSpaceCreateDeviceRGB` for image %@", imageToPredraw);
//        return imageToPredraw;
//    }
//    
//    // "In iOS 4.0 and later, and OS X v10.6 and later, you can pass NULL if you want Quartz to allocate memory for the bitmap." (source: docs)
//    voidvoid *data = NULL;
//    size_t width = imageToPredraw.size.width;
//    size_t height = imageToPredraw.size.height;
//    size_t bitsPerComponent = CHAR_BIT;//一个像素的单个组成部分的位数 如RGBA 此值指定R,G,B,A,每个分量占的位数为8bit。
//    
//#if 1
//    // Even when the image doesn't have transparency, we have to add the extra channel because Quartz doesn't support other pixel formats than 32 bpp/8 bpc for RGB:
//    // kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst, kCGImageAlphaPremultipliedLast
//    // (source: docs "Quartz 2D Programming Guide > Graphics Contexts > Table 2-1 Pixel formats supported for bitmap graphics contexts")
//    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpaceDeviceRGBRef) + 1; // 4: RGB + A
//    size_t bitsPerPixel = (bitsPerComponent * numberOfComponents);//一个像素点占用的位数 如RGBA=8*4
//    size_t bytesPerPixel = (bitsPerPixel / BYTE_SIZE);//一个像素点占用的字节数
//    size_t bytesPerRow = (bytesPerPixel * width);//一行的全部像素占用的字节数
//#else
//    size_t bytesPerRow = 0;//对于CGBitmapContextCreate函数当bytesPerRow=0系统不仅会为我们自动计算，而且还会进行 cache line alignment 的优化
//#endif
//    
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
//    
//    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageToPredraw.CGImage);
//    // If the alpha info doesn't match to one of the supported formats (see above), pick a reasonable supported one.
//    // "For bitmaps created in iOS 3.2 and later, the drawing environment uses the premultiplied ARGB format to store the bitmap data." (source: docs)
//    if (alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaOnly) {
//        alphaInfo = kCGImageAlphaNoneSkipFirst;
//    } else if (alphaInfo == kCGImageAlphaFirst) {
//        alphaInfo = kCGImageAlphaPremultipliedFirst;
//    } else if (alphaInfo == kCGImageAlphaLast) {
//        alphaInfo = kCGImageAlphaPremultipliedLast;
//    }
//    // "The constants for specifying the alpha channel information are declared with the `CGImageAlphaInfo` type but can be passed to this parameter safely." (source: docs)
//    bitmapInfo |= alphaInfo;
//    
//    // Create our own graphics context to draw to; `UIGraphicsGetCurrentContext`/`UIGraphicsBeginImageContextWithOptions` doesn't create a new context but returns the current one which isn't thread-safe (e.g. main thread could use it at the same time).
//    // Note: It's not worth caching the bitmap context for multiple frames ("unique key" would be `width`, `height` and `hasAlpha`), it's ~50% slower. Time spent in libRIP's `CGSBlendBGRA8888toARGB8888` suddenly shoots up -- not sure why.
//    //data为NULL系统自动分配内存空间
//    CGContextRef bitmapContextRef = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpaceDeviceRGBRef, bitmapInfo);
//    CGColorSpaceRelease(colorSpaceDeviceRGBRef);
//    // Early return on failure!
//    if (!bitmapContextRef) {
//        DLog(@"Failed to `CGBitmapContextCreate` with color space %@ and parameters (width: %zu height: %zu bitsPerComponent: %zu bytesPerRow: %zu) for image %@", colorSpaceDeviceRGBRef, width, height, bitsPerComponent, bytesPerRow, imageToPredraw);
//        return imageToPredraw;
//    }
//    
//    // Draw image in bitmap context and create image by preserving receiver's properties.
//    CGContextDrawImage(bitmapContextRef, CGRectMake(0.0, 0.0, imageToPredraw.size.width, imageToPredraw.size.height), imageToPredraw.CGImage);
//    CGImageRef predrawnImageRef = CGBitmapContextCreateImage(bitmapContextRef);
//    UIImage *predrawnImage = [UIImage imageWithCGImage:predrawnImageRef scale:imageToPredraw.scale orientation:imageToPredraw.imageOrientation];
//    CGImageRelease(predrawnImageRef);
//    CGContextRelease(bitmapContextRef);
//    
//    // Early return on failure!
//    if (!predrawnImage) {
//        DLog(@"Failed to `imageWithCGImage:scale:orientation:` with image ref %@ created with color space %@ and bitmap context %@ and properties and properties (scale: %f orientation: %ld) for image %@", predrawnImageRef, colorSpaceDeviceRGBRef, bitmapContextRef, imageToPredraw.scale, (long)imageToPredraw.imageOrientation, imageToPredraw);
//        return imageToPredraw;
//    }
//    
//    return predrawnImage;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end

