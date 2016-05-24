//
//  ViewController.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/12.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "ViewController.h"
#import "WKPhotoManager.h"


#import "WKPhotoPickerViewController.h"

#import "WKImageSelectedScrollView.h"

#import "WKPhotoBrowseVC.h"

@interface ViewController ()<WKPhotoBrowseVCDelegate,WKImageSelectedScrollViewDelegate,WKPhotoPickerViewControllerDelegate>

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
    //预先初始化 必要
    [WKPhotoManager sharedPhotoManager];
}


- (void)viewWillAppear:(BOOL)animated
{

}




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
        case WKSelectImageViewBtnClick_Delete://删除
        {
            [self.selectedImages removeObjectAtIndex:index];
        }
            break;
        case WKSelectImageViewBtnClick_Add://添加
        {
            [self selectPhotoAlbum];
        }
            break;
        case WKSelectImageViewBtnClick_Look://查看
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
- (NSMutableArray<UIImage *> *)imagesOfSelected
{
    return self.selectedImages;
}

// 选择中代理 包含新增加的值和被删除的值
- (void)changeToChooseWithDict:(NSDictionary *)dict
{

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

    for (UIImage * tempImage in self.selectedImages) {
        if ([tempImage wk_isEqualToImage:addImage]) {
            return;
        }
    }
    if(addImage)
        [self.selectedImages addObject:addImage];
}

#pragma mark WKPhotoBrowserVCDelegate methods

//图片源
- (NSArray<UIImage *> *)imagesOfSource
{
    return _selectedImages;
}
//当前显示的图片下标
- (NSUInteger)currentIndexOfImages
{
    return _presentImageIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
