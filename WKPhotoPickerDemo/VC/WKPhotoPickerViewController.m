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

@property (nonatomic, strong) NSMutableArray<UIImage *> * selectedImages;


//缩略图
@property (nonatomic, strong) NSArray<UIImage *> * sourceImages;
@property (nonatomic) NSUInteger maxImageCount;


@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) UILabel * hintLabel;

@end


@implementation WKPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _maxImageCount = 9;

    
    _cellSize = CGSizeMake(85*WIDTH_SCALE, 85*HEIGHT_SCALE);

    
    WKNavView * nav = [WKNavView viewFromNIB];
    nav.leftTitle = @"取消";
    nav.rightTitle = @"确定";
    nav.originS = CGPointMake(0, 0);
    [self.view addSubview:nav];
    nav.wkNVDelegate = self;
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    bottomView.backgroundColor = nav.backgroundColor;
    [self.view addSubview:bottomView];
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.textColor = [UIColor whiteColor];
    _hintLabel.sizeS = CGSizeMake(150, 20);
    _hintLabel.center = CGPointMake(bottomView.widthS / 2, bottomView.heightS / 2);
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:_hintLabel];
    
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = _cellSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 2.5, 5,2.5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, nav.bottomS, SCREEN_WIDTH, SCREEN_HEIGHT-nav.bottomS-bottomView.heightS) collectionViewLayout:flowLayout];
    
    UINib* cellNib=[UINib nibWithNibName:@"WKPhotoCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"WKPhotoCollectionViewCell"];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];

    
    
    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(numberOfSelectMax)]) {
        _maxImageCount = [_wkDelegate numberOfSelectMax];
    }
    
    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(imagesOfSelected)]) {
        _selectedImages = [[_wkDelegate imagesOfSelected] mutableCopy];
    }
    
    if(self.selectedImages == nil)
        self.selectedImages = [NSMutableArray array];
    
    _hintLabel.text = [NSString stringWithFormat:@"已选择%lu/%lu张图片",(unsigned long)self.selectedImages.count,_maxImageCount];

    
    [[WKPhotoManager sharedPhotoManager] refreshDataWithBlock:^(NSArray<UIImage *> *sourceImages) {
        self.sourceImages = sourceImages;
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

#pragma warning 多相册模式时 为nil 或者选中数量为0 不能传，因为可能相册不同
#pragma warning 只有全部照片，没有其他相册模式时，则应该传
- (void)rightBtnClick:(UIButton *)btn
{

    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(chooseToComplete:)]) {
        
        [_wkDelegate chooseToComplete:self.selectedImages];
    }
    
    if (self.navigationController != nil) {

        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return _sourceImages.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   WKPhotoCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"WKPhotoCollectionViewCell" forIndexPath:indexPath];

    NSUInteger index = indexPath.row;
    //顺序不可变
    cell.image = indexPath.row == 0 ? nil : _sourceImages[index - 1];
    cell.wk_state = indexPath.row == 0 ? WKPhotoCollectionViewCellState_None :WKPhotoCollectionViewCellState_Optional;
    BOOL flag = NO;
    
    if(cell.image)
    {
        for (UIImage * temp in self.selectedImages) {
            if ([temp wk_isEqualToImage:cell.image]) {
                flag = YES;
            }
            if (flag) {
                cell.isSelected = YES;
                break;
            }
        }
    }
    
    return cell;
}

-(void)selectCameraModel
{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if(([deviceString isEqualToString:@"i386"] ||  [deviceString isEqualToString:@"x86_64"]))
    {
        NSLog(@"对不起模拟器不支持相机功能，请用真机测试");
        return;
    }
    
    UIAlertController * sheetAlertController = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * defaultCamera =[UIAlertAction actionWithTitle:@"系统相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _cameraController = [[WKImagePickerController alloc]initWithModel:WKImagePickerControllerModel_Default];
        _cameraController.wkImagePickerDelegate = self;
        [self presentViewController:_cameraController animated:YES completion:nil];

    }];
    UIAlertAction * watermarkCamera =[UIAlertAction actionWithTitle:@"水印相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        _cameraController = [[WKImagePickerController alloc]initWithModel:WKImagePickerControllerModel_WaterMark];
        _cameraController.wkImagePickerDelegate = self;
        [self presentViewController:_cameraController animated:YES completion:nil];
    }];
    
    UIAlertAction * canle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [sheetAlertController addAction:canle];
    [sheetAlertController addAction:defaultCamera];
    [sheetAlertController addAction:watermarkCamera];
    [self presentViewController:sheetAlertController animated:YES completion:nil];
    
}

- (void)takePhoto:(UIImage *)image
{
    NSMutableDictionary * delegateDict = [NSMutableDictionary dictionary];

    //超过则先移除
    if (self.selectedImages.count >= 9) {
        [delegateDict setValue:self.selectedImages[0] forKey:@"0"];

        [self.selectedImages removeObjectAtIndex:0];

    }

    
    //添加

    [self.selectedImages addObject:image];
    [delegateDict setValue:image forKey:@"1"];

    _hintLabel.text = [NSString stringWithFormat:@"已选择%lu/%lu张图片",(unsigned long)self.selectedImages.count,_maxImageCount];

    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(changeToChooseWithDict:)]) {
        [_wkDelegate changeToChooseWithDict:delegateDict];
    }
    //刷新数据
    [[WKPhotoManager sharedPhotoManager] refreshDataWithBlock:^(NSArray<UIImage *> *sourceImages) {
        self.sourceImages = sourceImages;
        [_collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //打开相机
        [self selectCameraModel];
    }
    else
    {
//        
        WKPhotoCollectionViewCell * cell = (WKPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSUInteger index = indexPath.row ;
        
        NSMutableDictionary * delegateDict = [NSMutableDictionary dictionary];
        if (!cell.isSelected) {
            //当数量超过时
            if (self.selectedImages.count >= _maxImageCount) {

                UIImage * image = self.selectedImages[0];
                
                BOOL flag = NO;
                //判断对应的图片在不在当前源中
                for (UIImage * tempImage in _sourceImages) {
                    if ([tempImage wk_isEqualToImage:image]) {
                        flag = YES;
                        break;
                    }
                }
                if(flag)
                {
                    //在则，并把对应数据的cell状态改为未选中
                      NSIndexPath * path = [NSIndexPath indexPathForRow:image.wk_index.integerValue inSection:indexPath.section];
                    WKPhotoCollectionViewCell * cell = (WKPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:path];
                    cell.isSelected = NO;
                }
                //获取数据 用于代理
                [delegateDict setValue:self.selectedImages[0] forKey:@"0"];
                //移除第一个数据
                [self.selectedImages removeObjectAtIndex:0];
                
            }
            //新增
            [self.selectedImages addObject:_sourceImages[index - 1]];
            [delegateDict setValue:_sourceImages[index - 1] forKey:@"1"];

            
        }
        else
        {
            for (UIImage * tempImage in self.selectedImages) {
                if([cell.image wk_isEqualToImage:tempImage])
                {
                    [self.selectedImages removeObject:tempImage];
                    break;
                }
            }
            [delegateDict setValue:cell.image forKey:@"0"];

        }
        _hintLabel.text = [NSString stringWithFormat:@"已选择%lu/%lu张图片",(unsigned long)self.selectedImages.count,_maxImageCount];
        cell.isSelected = !cell.isSelected;
        if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(changeToChooseWithDict:)]) {
            [_wkDelegate changeToChooseWithDict:delegateDict];
        }

    }
}



- (void)setSourceImages:(NSArray<UIImage *> *)sourceImages
{
    _sourceImages = sourceImages;
    //生成下标 标识符 不能在其他时候生成
    for (NSUInteger i = 0; i < _sourceImages.count; i ++) {
        _sourceImages[i].wk_index = [NSString stringWithFormat:@"%lu",i + 1];
    }
}




@end
