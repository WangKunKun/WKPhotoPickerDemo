//
//  WKPhotoBrowseVC.h
//  WKPhotoPickerDemo
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKPhotoBrowseVCDelegate <NSObject>


@required


//已经选择图片 包含key 和 image  不支持跨相册
- (NSArray<UIImage *> *)imagesOfSource;

@optional

- (NSUInteger)currentIndexOfImages;


@end

@interface WKPhotoBrowseVC : UIViewController


@property (nonatomic, assign) id<WKPhotoBrowseVCDelegate> wkDelegate;

@end
