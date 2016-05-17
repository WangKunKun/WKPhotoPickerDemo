//
//  WKPhotoManager.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/13.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "WKPhotoManager.h"

static NSString * WKAlbumName = @"WKPhotoPickerDemo";

@interface WKPhotoManager ()

@property (nonatomic, strong) PHImageManager *imageManager;

@property (nonatomic, strong) NSMutableArray <PHFetchResult *> * albums;


@property (nonatomic, strong) NSMutableArray <NSDictionary *> * imageDicts;
@property (nonatomic, strong) NSMutableArray <UIImage *> * thumbs;
@property (nonatomic, strong) NSMutableArray <UIImage *> * sourceImages;

@property (nonatomic, strong) NSMutableArray <NSString *> * albumNamesM;

@property (nonatomic, strong) NSMutableArray <PHAssetCollection *> * collections;

@property (nonatomic, assign) BOOL hasWKAlbum;
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
        PM.albums = [NSMutableArray array];
        PM.albumNamesM = [NSMutableArray array];
        PM.collections = [NSMutableArray array];
        PM.currentAlbumIndex = 0;
        PM.imageSize = CGSizeMake(200, 200);
        PM.contentModel = WKPhotoContentModel_Fit;
        PM.hasWKAlbum = NO;
        [PM initAllPhotoData];
    });
    
    
    
    return PM;
}


-(void)initAllPhotoData
{
    
    [self.albums removeAllObjects];
    [self.albumNamesM removeAllObjects];
    [self.collections removeAllObjects];
    if (_photoOptions == nil) {
        _photoOptions = [[PHFetchOptions alloc] init];
    }
    if (_photoOptions.sortDescriptors.count <= 0) {
        _photoOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    }
    PHFetchResult  * allPhotos = [PHAsset fetchAssetsWithOptions:_photoOptions];
    
    
    [self.albums addObject:allPhotos];
    [self.albumNamesM addObject:@"所有照片"];
    [self getalbumResultWithType:PHAssetCollectionTypeAlbum];
//    [self getalbumResultWithType:PHAssetCollectionTypeSmartAlbum];
    _albumNames = [_albumNamesM copy];

    if (_hasWKAlbum == NO) {
        static NSUInteger i = 0;
        [self creatWKAlbum];
    }
    
}


- (void)getalbumResultWithType:(PHAssetCollectionType)type
{
    
    
    // 列出所有相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//            NSLog(@"%@",assetCollection.localizedTitle);
            
            if ([assetCollection.localizedTitle isEqualToString:WKAlbumName]) {
                _hasWKAlbum = YES;
                //做所有照片的
                [self.collections insertObject:assetCollection atIndex:0];
            }
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:_photoOptions];
            [self.albums addObject:fetchResult];
            [self.albumNamesM addObject:assetCollection.localizedTitle];
            [self.collections addObject:assetCollection];
            
        }else
        {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
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

- (void)refreshDataWithBlock:(WKPhotoRefreshDataBlock)block
{
#pragma warning 异步处理
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initAllPhotoData];
        [self.imageDicts removeAllObjects];
        [self.thumbs      removeAllObjects];
        [self.sourceImages removeAllObjects];
        
        for (PHAsset* asset in self.albums[self.currentAlbumIndex]) {
            PHImageRequestOptions * imageRequest_Option=[[PHImageRequestOptions alloc]init];
            imageRequest_Option.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
            //不允许网络加载
            imageRequest_Option.networkAccessAllowed=NO;
            imageRequest_Option.synchronous=YES;
//            NSLog(@"%@",asset.localIdentifier);
        
            [_imageManager requestImageForAsset:asset targetSize:_imageSize contentMode:_contentModel options:imageRequest_Option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                static NSUInteger i = 1;
                
                
                if (result != nil) {
                    result.wk_assetID = asset.localIdentifier;
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





- (void)saveImage:(UIImage *)image  completion:(WKPhotoSaveImageBlock)block
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied)
    {
        NSLog(@"请到【设置-隐私-照片】打开访问开关");
    }
    else if (status == PHAuthorizationStatusRestricted)
    {
        NSLog(@"无法访问相册");
    }
    else
    {

        
        // 保存相片的标识
        __block NSString *assetId = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 保存相片到相机胶卷，并返回标识
            assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                NSLog(@"系统相册 保存失败：%@", error);
                return;
            }
            
            // 根据标识获得相片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].lastObject;
            
            NSLog(@"唯一标识：%@",assetId);
            NSLog(@"asset标识：%@",asset.localIdentifier);
            image.wk_assetID = assetId;
            
            // 拿到自定义的相册对象

            PHAssetCollection *collection = _collections[_currentAlbumIndex];
            //保存到地自定义相册
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] addAssets:@[asset]];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"保存成功");
                    
                    block(image);
                    
                } else {
                    NSLog(@"自定义相册 保存失败：%@", error);
                }
            }];
 
        }];
    }
}

- (void)creatWKAlbum
{
    //新建相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
       id a =  [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:WKAlbumName];
        NSLog(@"%@",a);
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"创建成功");
            _hasWKAlbum = YES;
            [self initAllPhotoData];
        }
        else
        {
            NSLog(@"创建失败——错误信息：%@",error.localizedDescription);
        }
    }];
}


@end
