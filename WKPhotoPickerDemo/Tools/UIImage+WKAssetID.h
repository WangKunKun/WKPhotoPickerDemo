//
//  UIImage+WKAssetID.h
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/16.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WKAssetID)

//图片标识符
@property (nonatomic, strong) NSString * wk_assetID;
//索引下标
@property (nonatomic, strong) NSString * wk_index;

- (BOOL)wk_isEqualToImage:(UIImage *)image;

@end
