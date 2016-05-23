//
//  WKPhotoManager.h
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/13.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    WKPhotoContentModel_Fit = 0,//图片显示模式
    WKPhotoContentModel_Fill,//图片显示模式
    
} WKPhotoContentModel;

//block，获取源数据
typedef void(^WKPhotoRefreshDataBlock)(NSArray<UIImage *> * sourceImages);
//保存图片
typedef void(^WKPhotoSaveImageBlock)(UIImage * image);

@interface WKPhotoManager : NSObject

//获取图片时的选择，可自定义排序方式 —— 默认按创建时间逆序排序
//可不设置
@property (nonatomic, strong) PHFetchOptions *photoOptions;//待拓展

@property (nonatomic, assign) CGSize imageSize;//返回图片的尺寸 默认200*200
@property (nonatomic, assign) WKPhotoContentModel contentModel;//图片裁剪模式 默认Fit
@property (nonatomic, assign) NSUInteger currentAlbumIndex;//当前相册数据的索引 默认0（全部照片）
@property (nonatomic, assign, readonly) NSUInteger albumCount;//相册数量 = 总相册数量 + 1（包含一个全部图片）
@property (nonatomic, strong, readonly) NSArray * albumNames;//相册名称



+ (WKPhotoManager *)sharedPhotoManager;
- (NSArray<UIImage *> *)getThumbWithSize:(CGSize)size;//获得图片的缩略图-显示需要
- (NSArray<UIImage *> *)getSourceImage;//获得原图


- (void)saveImage:(UIImage *)image completion:(WKPhotoSaveImageBlock)block;
//实时数据需刷新
- (void)refreshDataWithBlock:(WKPhotoRefreshDataBlock)block;

@end

