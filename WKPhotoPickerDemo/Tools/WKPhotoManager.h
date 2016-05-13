//
//  WKPhotoManager.h
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/13.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WKPhotoBlock)(NSArray<UIImage *> * sourceImages);

@interface WKPhotoManager : NSObject

+ (WKPhotoManager *)sharedPhotoManager;

- (NSArray<NSDictionary *> *)getPhotoForKV;//图片键值对数组 之所以用数组不用字典，是因为保证顺序，字典无需
- (NSArray<UIImage *> *)getThumbWithSize:(CGSize)size;//获得图片的缩略图-显示需要
- (NSArray<UIImage *> *)getSourceImage;//获得原图

//实时数据需刷新
- (void)refreshDataWithBlock:(WKPhotoBlock)block;

@end

