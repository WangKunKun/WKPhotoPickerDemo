//
//  QTDynamicPhotoPickerViewController.h
//  QTRunningBang
//
//  Created by qitian on 15/11/17.
//  Copyright © 2015年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKPhotoPickerViewController;
typedef enum : NSUInteger {
    WKPhotoPickerVC_Selected = 1,//选择了某张图片
    WKPhotoPickerVC_Cancle = 0,//取消了某张图片
} WKPhotoPickerVCState;

@protocol WKPhotoPickerViewControllerDelegate <NSObject>
#pragma warning 多相册模式下 请使用changeToChooseWithDict 改变图片
#pragma warning 单一模式则两者均可

@required
//选择完成 代理
- (void)chooseToComplete:(NSMutableArray<UIImage *> *)images;

//已经选择图片 包含key 和 image  不支持跨相册
- (NSMutableArray<UIImage *> *)imagesOfSelected;
@optional

//最大选择数量-默认为9
- (NSUInteger)numberOfSelectMax;

// 选择中代理 包含新增加的值和被删除的值
- (void)changeToChooseWithDict:(NSDictionary *)dict;

@end

@interface WKPhotoPickerViewController : UIViewController


@property (nonatomic, assign) id<WKPhotoPickerViewControllerDelegate>wkDelegate;



@end
