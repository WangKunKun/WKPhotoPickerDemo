//
//  QTImagePickerController.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKImagePickerControllerModel_Default = 1,
    WKImagePickerControllerModel_WaterMark = 0,
} WKImagePickerControllerModel;

@protocol WKImagePickerControllerDelegate <NSObject>

- (void)takePhoto:(UIImage *)image;

@end

@interface WKImagePickerController : UIImagePickerController

- (id)initWithModel:(WKImagePickerControllerModel)model;

@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, strong) NSString * albumName;

@property (nonatomic, assign, readonly) WKImagePickerControllerModel model;

@property (nonatomic, assign) id<WKImagePickerControllerDelegate> wkImagePickerDelegate;

@end
