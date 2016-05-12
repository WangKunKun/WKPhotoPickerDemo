//
//  WKCaptureImageView.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WKCaptureImageViewBtnClick)(NSUInteger tag, UIImage * image);

@interface WKCaptureImageView : UIView

//距离
@property (nonatomic, assign) CGFloat distance;

//水印图片
@property (nonatomic, strong) UIImage * watemarkImage;
//主图片
@property (nonatomic, strong) UIImage * mainImage;

@property (nonatomic, copy) WKCaptureImageViewBtnClick click;

@property (nonatomic, strong, readonly) UIImage * saveImage;
+ (instancetype)viewFromNIB;

@end
