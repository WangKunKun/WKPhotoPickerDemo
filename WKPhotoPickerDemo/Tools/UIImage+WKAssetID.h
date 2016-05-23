//
//  UIImage+WKAssetID.h
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/16.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WKAssetID)

//图片标识符——从系统获取 一定是唯一
@property (nonatomic, strong) NSString * wk_assetID;
//索引下标，选择图片时需使用
@property (nonatomic, strong) NSString * wk_index;
//判断图片是否相等
- (BOOL)wk_isEqualToImage:(UIImage *)image;

@end
