//
//  WKImageView.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKSelectImageViewBtnClick_Delete,//删除图片
    WKSelectImageViewBtnClick_Add,//添加图片
    WKSelectImageViewBtnClick_Look,//查看图片
} WKSelectImageViewBtnClickStyle;

@class WKSelectImageView;

@protocol WKSelectImageViewDelegate <NSObject>

- (void)selectImageView:(WKSelectImageView *)sender style:(WKSelectImageViewBtnClickStyle)style;

@end

@interface WKSelectImageView : UIView

@property (nonatomic, strong) UIImage * presentImage;
@property (nonatomic, assign) id<WKSelectImageViewDelegate> wkDelegate;

+ (instancetype)viewFromNIB;

@end
