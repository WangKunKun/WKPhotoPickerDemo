//
//  UIImage+WKScreenshots.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WKScreenshots)


+ (UIImage *)getTargetViewScreenShotImageWithView:(UIView *)TargetView;//得到UIKit层面截图
+ (UIImage *)getFullImageWithView:(UIView *)view;//得到截图 包括图层截图
- (UIImage *)compressImage:(CGSize)size;//压缩图片
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;//为图片设置透明度
+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage;//合并图片
@end
