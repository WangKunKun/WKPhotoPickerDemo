//
//  UIImage+WKScreenshots.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "UIImage+WKScreenshots.h"

#import <OpenGLES/ES1/glext.h>

@implementation UIImage (WKScreenshots)


//屏幕截图 获得layer层截图
+ (UIImage *) glToUIImageWithView:(UIView *)view {
    
    
    //View并没有什么鸟用
    
    CGFloat scale = 2.0;
    if (is_iPhone6plus) {
        scale = 3.0;
    }
    
    NSUInteger width = SCREEN_WIDTH * scale;
    NSUInteger height = (SCREEN_HEIGHT - 64) * scale;
    NSLog(@"width = %ld  height = % ld",width,height);
    NSInteger myDataLength = width * height * 4;  //1024-width，768-height
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(NSUInteger y = 0; y < height; y++)
    {
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    NSUInteger bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
   
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return myImage;
}

//UIKit 截图
+(UIImage *)getTargetViewScreenShotImageWithView:(UIView *)TargetView{
    
    UIGraphicsBeginImageContextWithOptions(TargetView.frame.size, NO, 3);
    [ TargetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



//合并图片
+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    CGSize imageSize = firstImage.size ;
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

//为图片设置透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//压缩图片到指定大小
- (UIImage *)compressImage:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [self drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

+ (UIImage *)getFullImageWithView:(UIView *)view
{
    UIImage * frist = [self glToUIImageWithView:view];
    
    UIImage * second = [self getTargetViewScreenShotImageWithView:view];
    UIImage * compressImage = [frist compressImage:second.size];
    UIImage * image = [self mergerImage:compressImage secodImage:second];
    

    return image;
}
@end
