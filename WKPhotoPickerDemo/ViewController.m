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

@property (nonatomic, strong) NSMutableArray * waitingActionImages;

@property (nonatomic, assign) NSUInteger presentAlbumIndex;

@property (nonatomic, strong) NSMutableArray * selectedImages;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    _selectedImages = [NSMutableArray array];
    
    _waitingActionImages = [NSMutableArray array];
    _scrollView = [[WKImageSelectedScrollView alloc] initWithImages:nil frame:CGRectMake(0, 200, SCREEN_WIDTH, 200)];
    [self.view addSubview:_scrollView];
    _scrollView.wkDelegate = self;
    
    _presentAlbumIndex = 0;
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
            [_waitingActionImages removeObjectAtIndex:index];
            [self.selectedImages removeObjectAtIndex:index];
        }
            break;
        case WKSelectImageViewBtnClick_Add:
        {
            
            //单一模式
#if WKSingleModel
            WKPhotoPickerViewController * vc = [[WKPhotoPickerViewController alloc] init];
            //            vc.selectedImages = self.selectedImages;
            vc.wkDelegate = self;
            [self presentViewController:vc animated:YES completion:nil];
#else//多相册模式  多相册模式不具备跨相册多选功能 —— 后续会增加
            [self selectPhotoAlbum];
#endif
            
            
        }
            break;
        case WKSelectImageViewBtnClick_Look:
        {
            
//            if (_waitingActionImages.count > 0) {
                WKPhotoBrowseVC * pbvc = [[WKPhotoBrowseVC alloc] init];
                pbvc.wkDelegate = self;
                [self presentViewController:pbvc animated:YES completion:nil];
//            }

        }
            break;
            
        default:
            break;
    }
}
#pragma mark WKPhotoPickerVCDelegate
//选择完成 代理
- (void)chooseToComplete:(NSMutableArray<NSDictionary *> *)images
{

#if WKSingleModel
    self.selectedImages = images;
#endif
    if (self.selectedImages) {
        [_waitingActionImages removeAllObjects];
        for (NSDictionary * dict in self.selectedImages) {
            [_waitingActionImages addObjectsFromArray:[dict allValues]];
        }
        
        _scrollView.images = self.waitingActionImages ;
    }
}
//最大选择数量
- (NSUInteger)numberOfSelectMax
{
#if WKSingleModel
    return 9;
#else
    return 9 - self.selectedImages.count;
#endif

}
//已经选择图片 包含key 和 image  不支持跨相册
- (NSMutableArray<NSDictionary *> *)imagesOfSelected
{
    //多相册模式下
    
#if WKSingleModel
    return self.selectedImages;
#else
    return nil;
#endif
    
}

// 选择中代理 包含新增加的值和被删除的值
- (void)changeToChooseWithDict:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
#if WKSingleModel

#else
    NSArray * keys = [dict allKeys];
    NSDictionary * oldDict = nil;
    NSDictionary * newDict = nil;
    for (NSString * key in keys) {
        if ([key isEqualToString:@"0"]) {
            oldDict = [dict objectForKey:key];
        }
        else if([key isEqualToString:@"1"])
        {
            newDict = [dict objectForKey:@"1"];
        }
    }
    [self.selectedImages removeObject:oldDict];
    
    //过滤同一图片 无法过滤 除非重写UIImage
    UIImage * image = [newDict allValues][0];
    BOOL isExist = NO;
    for (NSDictionary * dict in self.selectedImages) {
        UIImage * thisImage = [dict allValues][0];
        if ([image isEqual:thisImage]) {
            isExist = YES;
            return;
        }
    }
    if (newDict != nil) {
        [self.selectedImages addObject:newDict];
    }
#endif
    
}

- (NSArray<UIImage *> *)imagesOfSource
{
    return _waitingActionImages;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
