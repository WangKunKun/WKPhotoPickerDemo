//
//  QTDynamicPhotoPickerViewController.m
//  QTRunningBang
//
//  Created by qitian on 15/11/17.
//  Copyright © 2015年 qitianxiongdi. All rights reserved.
//



#import "QTDynamicPhotoPickerViewController.h"
#import "WKPhotoCollectionViewCell.h"



#import <Photos/Photos.h>


@interface QTDynamicPhotoPickerViewController ()
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  UIImagePickerController *cameraController;//相机控制器
@property (nonatomic, strong) PHImageManager *imageManager;


@property (nonatomic, strong) NSMutableArray * imagesDataSource;

@end

@implementation QTDynamicPhotoPickerViewController
{
    PHFetchResult *allPhotos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imagesDataSource = [NSMutableArray array];
    if(_selectedImagesArr == nil)
        _selectedImagesArr = [NSMutableArray array];
    _imageManager=[PHImageManager defaultManager];
    [self initUIImagePickerController];
    [self initCollectionView];
    [self initAllPhotoData];

    _selectedConterLabel.text = [NSString stringWithFormat:@"已选择%lu/%lu张图片",_selectedImagesArr.count,_maxImageCount];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initCollectionView{

   
    UINib* cellNib=[UINib nibWithNibName:@"WKPhotoCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"WKPhotoCollectionViewCell"];
    
   

    
    
    
}
-(void)initAllPhotoData
{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self setCellImageDictDataWithFetchResult:allPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_collectionView reloadData];
            
        });
        
        
    });
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}
-(void)setCellImageDictDataWithFetchResult:(PHFetchResult*)result{
    
    
    [_imagesDataSource removeAllObjects];
    //    获取缩略图给Cell
    for (PHAsset* asset in result) {
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
                [_imagesDataSource addObject:result];
                i ++;

            }
            
        }];
    }
    NSLog(@"总图片_%lu",result.count);

    NSLog(@"读取出来的图片_%lu",_imagesDataSource.count);
    
    [_collectionView reloadData];
    
}
- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(SCREEN_WIDTH * scale, SCREEN_HEIGHT * scale);
    return targetSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    
    if (_imagesDataSource.count==0) {
        return 1;
    }
    return _imagesDataSource.count+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.row==0) {
//        
//        QTDynamicTakephotoCollectionViewCel* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"QTDynamicTakephotoCollectionViewCel" forIndexPath:indexPath];
//        
//        return cell;
//    }
//    else
//    {
//        
//        QTDynamicPhotoPickerCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"QTDynamicPhotoPickerCollectionViewCell" forIndexPath:indexPath];
//
//        NSUInteger index = indexPath.row;
//        NSString * key = [NSString stringWithFormat:@"%lu",index];
//        
////        NSLog(@"%@",[_imagesDataSource[index] objectForKey:key]);
//        
//        cell.backgroundPhotoImageView.image = _imagesDataSource[index - 1] ;
//
//        
//        cell.backgroundPhotoImageView.contentMode=UIViewContentModeScaleAspectFill;
//        cell.backgroundPhotoImageView.clipsToBounds=YES;
//        
//
//        cell.isSelected = NO;
//        
//        BOOL flag = NO;
//        for (NSDictionary * dict in _selectedImagesArr) {
//            NSArray * arr =  [dict allKeys];
//            for (NSString * tempKey in arr) {
//                if ([tempKey isEqualToString:key]) {
//                    flag = YES;
//                    break;
//                }
//            }
//            if (flag) {
//                cell.isSelected = YES;
//                break;
//            }
//        }
//        
//        
//        return  cell;
//    }
    
 
    return nil;
}

#pragma 相应事件
-(void)initUIImagePickerController{
    _cameraController=[[UIImagePickerController alloc]init];
    _cameraController.sourceType=UIImagePickerControllerSourceTypeCamera;
    _cameraController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _cameraController.editing=YES;
    _cameraController.showsCameraControls=YES;
    _cameraController.delegate=self;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //打开相机

      [self presentViewController:_cameraController animated:YES completion:nil];
        
    }
    else
    {
//        
//        QTDynamicPhotoPickerCollectionViewCell * cell = (QTDynamicPhotoPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//
//        NSUInteger index = indexPath.row ;
//        NSString * key = [NSString stringWithFormat:@"%lu",index];
//        if (!cell.isSelected) {
//            //当数量超过时
//            if (_selectedImagesArr.count >= _maxImageCount) {
//
//                NSDictionary * dict = _selectedImagesArr[0];
//                NSArray * keys = [dict allKeys];
//                //移除第一个数据
//                //并把对应数据的cell状态改为未选中
//                for (NSString * tempKey in keys) {
//                    NSIndexPath * path = [NSIndexPath indexPathForRow:tempKey.integerValue inSection:indexPath.section];
//                    QTDynamicPhotoPickerCollectionViewCell * cell = (QTDynamicPhotoPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:path];
//                    cell.isSelected = NO;
//                }
//                [_selectedImagesArr removeObjectAtIndex:0];
//            }
//            //新增
//            NSDictionary * dict = @{key:cell.backgroundPhotoImageView.image};
//            [_selectedImagesArr addObject:dict];
//
//
//        }
//        else
//        {
//            BOOL deleteFlag = NO;
//            for (NSDictionary * dict in _selectedImagesArr) {
//               NSArray * arr =  [dict allKeys];
//                for (NSString * tempKey in arr) {
//                    if ([tempKey isEqualToString:key]) {
//                        deleteFlag = YES;
//                        break;
//                    }
//                }
//                if (deleteFlag) {
//                    [_selectedImagesArr removeObject:dict];
//                    break;
//                }
//            }
//        }
//        cell.isSelected = !cell.isSelected;
//        _selectedConterLabel.text = [NSString stringWithFormat:@"已选择%lu/%lu张图片",_selectedImagesArr.count,_maxImageCount];
//
    }
}
#pragma  相机回调


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //保存到 相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
//    UIImage *  targetImage = [QTUtils imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width/4, image.size.height/4)];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //点击使用照片 才会如何?
        
        //超过则先移除
        if (_selectedImagesArr.count >= 9) {
            [_selectedImagesArr removeObjectAtIndex:0];
        }
        
        //所有选中图片的 images的key + 1;
        
        for (NSUInteger i = 0 ; i < _selectedImagesArr.count ;i ++) {
            NSDictionary * oldDict = _selectedImagesArr[i];
            NSArray * arr = [oldDict allKeys];
            NSMutableDictionary * newDict = [[NSMutableDictionary alloc] init];
            for (NSString * key in arr) {
                NSUInteger index = [key integerValue];
                index += 1;
                NSString * newKey = [NSString stringWithFormat:@"%lu",index];
                [newDict setObject:[oldDict valueForKey:key] forKey:newKey];
            }
            [_selectedImagesArr removeObjectAtIndex:i];
            [_selectedImagesArr insertObject:newDict atIndex:i];
            
        }
        
        //添加
//        NSDictionary * dict = @{@"1":targetImage};
//        [_selectedImagesArr insertObject:dict atIndex:0];

        
        //重新加载
        [self initAllPhotoData];
        

    }];

}

- (IBAction)finishSelectedImage:(id)sender {


   
    [self getSourceImage];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:FINISHSELECTEDIMAGE object:self userInfo:[NSDictionary dictionaryWithObject:_passValueImageArray forKey:FINISHSELECTEDIMAGE]];
    

//    if ([self.presentingViewController isKindOfClass:[QTHXSubmitMatchResultViewController class]]) {
//        QTHXSubmitMatchResultViewController * vc = (QTHXSubmitMatchResultViewController *)self.presentingViewController;
////        vc.selectedImages = _selectedImagesDataSource;
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
//    
//    NSArray * vcs = self.navigationController.viewControllers;
//    UIViewController * vc = vcs[vcs.count - 2];
//    
//    if (vc && ([vc isKindOfClass:[QTDynamicPublishViewController class]] || [vc isKindOfClass:[QTHXSportsSubmitEvaluationViewController class]] || [vc isKindOfClass:[QTHXSubmitMatchResultViewController class]])) {
//        QTDynamicPublishViewController * temp = (QTDynamicPublishViewController *)vc;
//        temp.imageDataSource = _selectedImagesArr;
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
//    
    [self backBtnClickAction:nil];
}
-(void)getSourceImage
{
    
    PHImageRequestOptions * imageRequest_Option=[[PHImageRequestOptions alloc]init];
    imageRequest_Option.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //不允许网络加载
    imageRequest_Option.networkAccessAllowed=NO;
    
    //一定要设为 同步'YES' ,不然以上全部无效
    imageRequest_Option.synchronous=YES;

    
    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * dict in _selectedImagesArr) {
        [arr addObjectsFromArray:[dict allKeys]];
    }
    
    
    [_selectedImagesArr removeAllObjects];
    for (NSString * index in arr)
    {
        NSLog(@"%lu",index.integerValue - 1);
        [_imageManager requestImageForAsset:allPhotos[index.integerValue - 1]
                                 targetSize:CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2)
                                contentMode:PHImageContentModeAspectFit
                                    options:imageRequest_Option
                              resultHandler:^(UIImage *result, NSDictionary *info)
         {
//                                  NSLog(@"图片信息:%@",info);
                                    NSDictionary * dict = @{index:result};
                                  [_selectedImagesArr addObject:dict];
                                  
         }];
    }


    

}
#pragma cell样式
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(85*WIDTH_SCALE, 85*HEIGHT_SCALE);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 2.5, 5,2.5);
}
- (IBAction)backBtnClickAction:(id)sender {
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
