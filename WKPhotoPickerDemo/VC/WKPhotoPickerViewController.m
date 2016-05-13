//
//  QTDynamicPhotoPickerViewController.m
//  QTRunningBang
//
//  Created by qitian on 15/11/17.
//  Copyright © 2015年 qitianxiongdi. All rights reserved.
//



#import "WKPhotoPickerViewController.h"
#import "WKImagePickerController.h"
#import "WKPhotoCollectionViewCell.h"
#import "WKPhotoManager.h"
#import "sys/utsname.h"
#import "WKNavView.h"



@interface WKPhotoPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WKNavViewDelegate,WKImagePickerControllerDelegate>
@property (strong, nonatomic)  UICollectionView *collectionView;

@property (strong, nonatomic)  WKImagePickerController *cameraController;//相机控制器


//缩略图
@property (nonatomic, strong) NSArray * sourceImages;

@property (nonatomic, strong) NSMutableArray * selectedImageKeys;

@property (nonatomic, assign) CGSize cellSize;

@end


@implementation WKPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.selectedImages == nil)
        self.selectedImages = [NSMutableArray array];
    
    _cellSize = CGSizeMake(85*WIDTH_SCALE, 85*HEIGHT_SCALE);
    _maxImageCount = 9;
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if(!([deviceString isEqualToString:@"i386"] ||  [deviceString isEqualToString:@"x86_64"]))
    {
        [self initUIImagePickerController];
        
    }
    
    WKNavView * nav = [WKNavView viewFromNIB];
    nav.leftTitle = @"取消";
    nav.rightTitle = @"确定";
    nav.originS = CGPointMake(0, 0);
    [self.view addSubview:nav];
    nav.wkNVDelegate = self;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = _cellSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 2.5, 5,2.5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, nav.bottomS, SCREEN_WIDTH, SCREEN_HEIGHT-nav.bottomS) collectionViewLayout:flowLayout];
    
    UINib* cellNib=[UINib nibWithNibName:@"WKPhotoCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"WKPhotoCollectionViewCell"];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    [[WKPhotoManager sharedPhotoManager] refreshDataWithBlock:^(NSArray<UIImage *> *sourceImages) {
//         _sourceImages = [[WKPhotoManager sharedPhotoManager] getThumbWithSize:_cellSize];
        _sourceImages = sourceImages;
        [_collectionView reloadData];
    }];
    
   
    self.view.backgroundColor = [UIColor whiteColor];

    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtnClick:(UIButton *)btn
{
    if (self.navigationController != nil) {

        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBtnClick:(UIButton *)btn
{
    if (self.navigationController != nil) {
        NSArray * vcs = self.navigationController.viewControllers;
        UIViewController * vc = vcs[vcs.count - 2];
        vc.selectedImages = self.selectedImages;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.presentingViewController.selectedImages = self.selectedImages;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return _sourceImages.count + 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   WKPhotoCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"WKPhotoCollectionViewCell" forIndexPath:indexPath];

    NSUInteger index = indexPath.row;
    NSString * key = [NSString stringWithFormat:@"%lu",index];
    //顺序不可变
    cell.image = indexPath.row == 0 ? nil : _sourceImages[index - 1];
    cell.wk_state = indexPath.row == 0 ? WKPhotoCollectionViewCellState_None : WKPhotoCollectionViewCellState_Optional;
    BOOL flag = NO;
    for (NSDictionary * dict in self.selectedImages) {
        NSArray * arr =  [dict allKeys];
        for (NSString * tempKey in arr) {
            if ([tempKey isEqualToString:key]) {
                flag = YES;
                break;
            }
        }
        if (flag) {
            cell.isSelected = YES;
            break;
        }
    }
    
    
    return cell;
}

#pragma 相应事件
-(void)initUIImagePickerController{
    _cameraController=[[WKImagePickerController alloc]init];
    _cameraController.wkImagePickerDelegate = self;
    
}

- (void)takePhoto:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //超过则先移除
    if (self.selectedImages.count >= 9) {
        [self.selectedImages removeObjectAtIndex:0];
    }
    
    //所有选中图片的 images的key + 1;
    
    for (NSUInteger i = 0 ; i < self.selectedImages.count ;i ++) {
        NSDictionary * oldDict = self.selectedImages[i];
        NSArray * arr = [oldDict allKeys];
        NSMutableDictionary * newDict = [[NSMutableDictionary alloc] init];
        for (NSString * key in arr) {
            NSUInteger index = [key integerValue];
            index += 1;
            NSString * newKey = [NSString stringWithFormat:@"%lu",index];
            [newDict setObject:[oldDict valueForKey:key] forKey:newKey];
        }
        [self.selectedImages removeObjectAtIndex:i];
        [self.selectedImages insertObject:newDict atIndex:i];
        
    }
    
    //添加
    NSDictionary * dict = @{@"1":image};
    [self.selectedImages insertObject:dict atIndex:0];
    
    //刷新数据
    [[WKPhotoManager sharedPhotoManager] refreshDataWithBlock:^(NSArray<UIImage *> *sourceImages) {
        _sourceImages = sourceImages;
        [_collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //打开相机
        
        if(!_cameraController)
        {
            NSLog(@"对不起模拟器不支持相机功能，请用真机测试");
            return;
        }
        [self presentViewController:_cameraController animated:YES completion:nil];
        
    }
    else
    {
//        
        WKPhotoCollectionViewCell * cell = (WKPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//
        NSUInteger index = indexPath.row ;
        NSString * key = [NSString stringWithFormat:@"%lu",index];
        if (!cell.isSelected) {
            //当数量超过时
            if (self.selectedImages.count >= _maxImageCount) {

                NSDictionary * dict = self.selectedImages[0];
                NSArray * keys = [dict allKeys];
                //移除第一个数据
                //并把对应数据的cell状态改为未选中
                for (NSString * tempKey in keys) {
                    NSIndexPath * path = [NSIndexPath indexPathForRow:tempKey.integerValue inSection:indexPath.section];
                    WKPhotoCollectionViewCell * cell = (WKPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:path];
                    cell.isSelected = NO;
                }
                [self.selectedImages removeObjectAtIndex:0];
            }
            //新增
            NSDictionary * dict = @{key:_sourceImages[index - 1]};
            [self.selectedImages addObject:dict];


        }
        else
        {
            BOOL deleteFlag = NO;
            for (NSDictionary * dict in self.selectedImages) {
               NSArray * arr =  [dict allKeys];
                for (NSString * tempKey in arr) {
                    if ([tempKey isEqualToString:key]) {
                        deleteFlag = YES;
                        break;
                    }
                }
                if (deleteFlag) {
                    [self.selectedImages removeObject:dict];
                    break;
                }
            }
        }
        cell.isSelected = !cell.isSelected;


    }
}
#pragma  相机回调


//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//        //保存到 相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    }
//    //刷新数据
//
//    
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        //点击使用照片 才会如何?
//        
//        //超过则先移除
//        if (self.selectedImages.count >= 9) {
//            [self.selectedImages removeObjectAtIndex:0];
//        }
//        
//        //所有选中图片的 images的key + 1;
//        
//        for (NSUInteger i = 0 ; i < self.selectedImages.count ;i ++) {
//            NSDictionary * oldDict = self.selectedImages[i];
//            NSArray * arr = [oldDict allKeys];
//            NSMutableDictionary * newDict = [[NSMutableDictionary alloc] init];
//            for (NSString * key in arr) {
//                NSUInteger index = [key integerValue];
//                index += 1;
//                NSString * newKey = [NSString stringWithFormat:@"%lu",index];
//                [newDict setObject:[oldDict valueForKey:key] forKey:newKey];
//            }
//            [self.selectedImages removeObjectAtIndex:i];
//            [self.selectedImages insertObject:newDict atIndex:i];
//            
//        }
//        
//        //添加
//        NSDictionary * dict = @{@"1":image};
//        [self.selectedImages insertObject:dict atIndex:0];
//
//        //刷新数据
//        [[WKPhotoManager sharedPhotoManager] refreshDataWithBlock:^(NSArray<UIImage *> *sourceImages) {
//            _sourceImages = sourceImages;
//            [_collectionView reloadData];
//        }];
//
//    }];
//
//}







@end
