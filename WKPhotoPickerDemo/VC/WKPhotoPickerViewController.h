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

@required
//选择完成 代理
- (void)chooseToComplete:(NSMutableArray<UIImage *> *)images;
//已选中的图片
- (NSMutableArray<UIImage *> *)imagesOfSelected;
@optional
//最大选择数量-默认为9
- (NSUInteger)numberOfSelectMax;

// 选择中代理 包含新增加的值和被删除的值  key 0 表删除掉得 key 1表新添加的
- (void)changeToChooseWithDict:(NSDictionary *)dict;

@end

@interface WKPhotoPickerViewController : UIViewController


@property (nonatomic, assign) id<WKPhotoPickerViewControllerDelegate>wkDelegate;



@end
