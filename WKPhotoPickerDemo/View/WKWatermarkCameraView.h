//
//  WKWatermarkCamera.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClick)(NSUInteger tag, BOOL selected);

@interface WKWatermarkCameraView : UIView

@property (nonatomic, copy) btnClick click;
//距离
@property (nonatomic, assign) CGFloat distance;

//水印图片
@property (strong, nonatomic, readonly) UIImage * saveImage;
+ (instancetype)viewFromNIB;
@end
