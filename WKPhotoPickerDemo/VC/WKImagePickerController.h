//
//  QTImagePickerController.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

//相机模式
typedef enum : NSUInteger {
    WKImagePickerControllerModel_Default = 1,//默认
    WKImagePickerControllerModel_WaterMark = 0,//水印
} WKImagePickerControllerModel;

@protocol WKImagePickerControllerDelegate <NSObject>

//相机拍照回调
- (void)takePhoto:(UIImage *)image;

@end

@interface WKImagePickerController : UIImagePickerController

//只支持在初始化时设置模式
- (id)initWithModel:(WKImagePickerControllerModel)model;
//距离 为了配合logo
@property (nonatomic, assign) CGFloat distance;

//制度模式
@property (nonatomic, assign, readonly) WKImagePickerControllerModel model;

//代理
@property (nonatomic, assign) id<WKImagePickerControllerDelegate> wkImagePickerDelegate;



@end
