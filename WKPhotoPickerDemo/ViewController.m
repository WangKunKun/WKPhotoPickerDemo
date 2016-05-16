//
//  ViewController.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/12.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "ViewController.h"
#import "WKImageSelectedScrollView.h"
#import "WKPhotoPickerViewController.h"
#import "WKPhotoManager.h"
#import "WKPhotoBrowseVC.h"



@interface ViewController ()<WKImageSelectedScrollViewDelegate,WKPhotoPickerViewControllerDelegate,WKPhotoBrowseVCDelegate>

@property (nonatomic, strong) WKImageSelectedScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray * selectedImages;

@property (nonatomic, assign) NSUInteger presentImageIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    _selectedImages = [NSMutableArray array];
    
    _scrollView = [[WKImageSelectedScrollView alloc] initWithImages:nil frame:CGRectMake(0, 200, SCREEN_WIDTH, 200)];
    [self.view addSubview:_scrollView];
    _scrollView.wkDelegate = self;
    
    _presentImageIndex = 0;
}


- (void)viewWillAppear:(BOOL)animated
{

}


#pragma warning 需求未用，因为要保留选择的图片的key，如果区分不同相册 保留太过繁琐，而且无法避免选择重复图片（因为拍照的新图片） 只能做到两次选择不同相册就不传，并且在返回时，如果为未选中任何图片，也不传回来。

#pragma mark 多相册模式 不具备 跨相册多选照片功能！
- (void)selectPhotoAlbum
{
    WKPhotoManager * pm = [WKPhotoManager sharedPhotoManager];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请选择相册" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSUInteger i = 0; i < pm.albumNames.count; i ++) {
        UIAlertActionStyle style = i == 0 ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
        UIAlertAction * tempAction = [UIAlertAction actionWithTitle:pm.albumNames[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            pm.currentAlbumIndex = i;
            
            WKPhotoPickerViewController * vc = [[WKPhotoPickerViewController alloc] init];
            
            vc.wkDelegate = self;
            //推送
            [self presentViewController:vc animated:YES completion:nil];

        }];
        [alertController addAction:tempAction];
    }
    
    UIAlertAction * canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:canleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma  mark wkScrollViewDelegate
- (void)wkScrollView:(WKImageSelectedScrollView *)wkScrollView DidClickAtIndex:(NSUInteger)index clickStyle:(WKSelectImageViewBtnClickStyle)style
{
    switch (style) {
        case WKSelectImageViewBtnClick_Delete:
        {
            [self.selectedImages removeObjectAtIndex:index];
        }
            break;
        case WKSelectImageViewBtnClick_Add:
        {
            
            [self selectPhotoAlbum];

            
            
        }
            break;
        case WKSelectImageViewBtnClick_Look:
        {
            
            _presentImageIndex = index;
            WKPhotoBrowseVC * pbvc = [[WKPhotoBrowseVC alloc] init];
            pbvc.wkDelegate = self;
            [self presentViewController:pbvc animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }
}
#pragma mark WKPhotoPickerVCDelegate
//选择完成 代理
- (void)chooseToComplete:(NSMutableArray<UIImage *> *)images
{

    self.selectedImages = images;
    _scrollView.images = images;

}
//最大选择数量
- (NSUInteger)numberOfSelectMax
{

    return 9 ;


}
//已经选择图片 包含key 和 image  不支持跨相册
- (NSMutableArray<UIImage *> *)imagesOfSelected
{
    //多相册模式下
    return self.selectedImages;
}

// 选择中代理 包含新增加的值和被删除的值
- (void)changeToChooseWithDict:(NSDictionary *)dict
{
    NSLog(@"%@",dict);

    NSArray * keys = [dict allKeys];
    UIImage * deleteImage = nil;
    UIImage * addImage = nil;
    for (NSString * key in keys) {
        if ([key isEqualToString:@"0"]) {
            deleteImage = [dict objectForKey:key];
        }
        else if([key isEqualToString:@"1"])
        {
            addImage = [dict objectForKey:@"1"];
        }
    }
    [self.selectedImages removeObject:deleteImage];
    
    //过滤同一图片 无法过滤 除非重写UIImage

    for (UIImage * tempImage in self.selectedImages) {
        if ([tempImage wk_isEqualToImage:addImage]) {
            return;
        }
    }
    
    if(addImage)
        [self.selectedImages addObject:addImage];
//#endif
    
}

#pragma mark WKPhotoBrowserVCDelegate methods

- (NSArray<UIImage *> *)imagesOfSource
{
    return _selectedImages;
}

- (NSUInteger)currentIndexOfImages
{
    return _presentImageIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
