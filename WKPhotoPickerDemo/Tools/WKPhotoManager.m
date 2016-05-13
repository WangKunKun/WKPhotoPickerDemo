//
//  WKPhotoManager.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/13.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "WKPhotoManager.h"
#import <Photos/Photos.h>



@interface WKPhotoManager ()

@property (nonatomic, strong) PHImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *allPhotos;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> * imageDicts;
@property (nonatomic, strong) NSMutableArray <UIImage *> * thumbs;
@property (nonatomic, strong) NSMutableArray <UIImage *> * sourceImages;

@end

@implementation WKPhotoManager

+ (WKPhotoManager *)sharedPhotoManager
{
    static WKPhotoManager * PM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PM = [[WKPhotoManager alloc] init];
        PM.imageManager=[PHImageManager defaultManager];
        PM.imageDicts = [NSMutableArray array];
        PM.thumbs = [NSMutableArray array];
        PM.sourceImages = [NSMutableArray array];

    });
    

    return PM;
}


-(void)initAllPhotoData
{

    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
}



- (NSArray<UIImage *> *)getSourceImage
{
    NSArray * images = [_sourceImages copy];
    return images;
}

- (NSArray<UIImage *> *)getThumbWithSize:(CGSize)size
{
    NSMutableArray * arr = [NSMutableArray array];
    
    for (UIImage * temp in _sourceImages) {
       [arr addObject:[temp compressImage:size]];
        
    }
    
    return [arr copy];
}

- (void)refreshDataWithBlock:(WKPhotoBlock)block
{
#pragma warning 异步处理
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initAllPhotoData];
        [self.imageDicts removeAllObjects];
        [self.thumbs removeAllObjects];
        [self.sourceImages removeAllObjects];
        
        for (PHAsset* asset in _allPhotos) {
            PHImageRequestOptions * imageRequest_Option=[[PHImageRequestOptions alloc]init];
            imageRequest_Option.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
            //不允许网络加载
            imageRequest_Option.networkAccessAllowed=NO;
            imageRequest_Option.synchronous=YES;
            [_imageManager requestImageForAsset:asset targetSize:CGSizeMake(200,200) contentMode:PHImageContentModeAspectFit options:imageRequest_Option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                static NSUInteger i = 1;
                if (result != nil) {
                    NSString * key = [NSString stringWithFormat:@"%lu",i];
                    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                    [dict setObject:result forKey:key];
                    [_imageDicts addObject:dict];
                    [_sourceImages addObject:result];
                    i ++;
                }
                
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(_sourceImages);
        });
        
    });
}

- (NSArray<NSDictionary *> *)getPhotoForKV
{
    return [_imageDicts copy];
}

@end
