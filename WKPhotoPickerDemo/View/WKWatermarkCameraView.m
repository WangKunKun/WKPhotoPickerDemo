//
//  WKWatermarkCamera.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#define BtnTag 100

#import "WKWatermarkCameraView.h"
#import "WKCameroCell.h"
@interface WKWatermarkCameraView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UIView *logoView;

@property (strong, nonatomic) NSMutableArray * logoImageArray;


@end


@implementation WKWatermarkCameraView



+ (instancetype)viewFromNIB
{
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"WKWatermarkCameraView" owner:nil options:nil];
    WKWatermarkCameraView * cv = views[0];
    [cv initData];
    
    UINib* cellNib=[UINib nibWithNibName:@"QTCameroLogoCell" bundle:nil];
    [cv.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"QTCameroLogoCell"];
    cv.collectionView.delegate = cv;
    cv.collectionView.dataSource = cv;
    return cv;
}
- (void)initData
{
    _logoImageArray=[[NSMutableArray alloc]init];
    //假数据
    [_logoImageArray addObject:GET_IMAGE(@"完成跑步-RuningBang·奔跑帮.png")];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    
    if (self.click) {
        self.click(sender.tag - BtnTag,sender.selected);
    }
    
}

#pragma LOGO水印选择及展示
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return _logoImageArray.count+1;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCameroCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"QTCameroLogoCell" forIndexPath:indexPath];
    
    if (indexPath.row==0) {
        cell.logoImageView.hidden=YES;
        cell.logoLabel.hidden=NO;
        cell.backgroundColor=[UIColor blackColor];
        return cell;
    }
    else
    {
        cell.logoImageView.hidden=NO;
        cell.logoLabel.hidden=YES;
        cell.logoImageView.image=_logoImageArray[indexPath.row-1];
        cell.logoImageView.contentMode=UIViewContentModeScaleAspectFit;
        cell.backgroundColor=[UIColor blackColor];
        return cell;
    }
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WKCameroCell * cell= (WKCameroCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row==0) {
        _logoView.hidden=YES;
        _logoLabel.hidden=YES;
        _logoImageView.hidden = YES;
        self.saveImage=nil;
    }
    else
    {
        _logoView.hidden=NO;
        _logoLabel.hidden=NO;
        _logoImageView.hidden = NO;
        self.saveImage = cell.logoImageView.image;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80*WIDTH_SCALE, 120*HEIGHT_SCALE);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 2.5, 5,2.5);
}

- (void)setSaveImage:(UIImage *)saveImage
{
    _saveImage = saveImage;
    self.logoImageView.image = saveImage;
}


- (void)setDistance:(CGFloat)distance
{
    _distance = distance;
    _logoLabel.text = [NSString stringWithFormat:@"%.2lf Km",distance/ 1000.0];
}
@end
