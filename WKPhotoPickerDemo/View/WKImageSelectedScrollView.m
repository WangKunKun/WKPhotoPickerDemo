//
//  WKImageSelectedScroolView.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKImageSelectedScrollView.h"
#import "QTDynamicPhotoPickerViewController.h"
#import "WKSBManager.h"

#define SCROLLVIEWWIDTH SCREEN_WIDTH
#define SCROLLVIEWHEIGHT (120)
#define BtnStartY (5)
#define BtnStartX (10)


#define BtnStartTag 200
@interface WKImageSelectedScrollView ()<WKSelectImageViewDelegate>

@property (nonatomic, strong) NSMutableArray * btnArr;
@property (nonatomic, strong) NSMutableArray * imagesM;

@end

@implementation WKImageSelectedScrollView


- (instancetype)initWithImages:(NSArray *)images frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _images = images;
        _imagesMaxCount = 9;
        _imagesM = _images == nil ? nil : [images mutableCopy];
        self.frame = frame;
        _btnArr = [NSMutableArray array];
        [self setInterFace];
//        [self initPhotoBrowser];
        
    }
    return self;
}





- (void)setImages:(NSArray<UIImage *> *)images
{
    _images = images;
    _imagesM = [images mutableCopy];
    [self setInterFace];
}

- (void)setInterFace
{
    CGFloat startX = 10;
    CGFloat startY = 0;
    CGFloat space = 10;
    
    //移除
    for (UIView * view in _btnArr) {
        [view removeFromSuperview];
    }
    [_btnArr removeAllObjects];
    

    //添加
    NSUInteger i = 0;
    for (UIImage * temp in _images) {
        WKSelectImageView * selectImageView = [WKSelectImageView viewFromNIB];
        selectImageView.presentImage = temp;
//        selectImageView.originS = CGPointMake(startX, startY);
        [self addSubview:selectImageView];
//        startX += selectImageView.widthS + space;
        [_btnArr addObject:selectImageView];
        selectImageView.wkDelegate = self;
        selectImageView.tag = BtnStartTag + i;
        i++;
        if (i >= _imagesMaxCount) {
            break;
        }
    }
  
    BOOL animationFlag = i == 0 ;
//    CGFloat newStartX = animationFlag ? startX + SCREEN_WIDTH : startX;
    //添加最后的
    if (i < _imagesMaxCount) {
        
        
        
        WKSelectImageView * selectImageView = [WKSelectImageView viewFromNIB];
//        selectImageView.originS =CGPointMake(newStartX, startY);
        [self addSubview:selectImageView];
//        newStartX += selectImageView.widthS + space;
        selectImageView.tag = BtnStartTag + i;
        selectImageView.wkDelegate = self;
        [_btnArr addObject:selectImageView];
        
        

        
    }

//    self.contentSize = CGSizeMake(newStartX, self.heightS);
    //执行动画
    
}

- (void)selectImageView:(WKSelectImageView *)sender style:(WKSelectImageViewBtnClickStyle)style
{
    switch (style) {
        case WKSelectImageViewBtnClick_Delete:
            
            //移除
            [_imagesM removeObjectAtIndex:sender.tag - BtnStartTag];
            self.images = [_imagesM copy];
            
            break;
        
            
        default:
            break;
    }
    
    if (_wkVCDelegate && [_wkVCDelegate respondsToSelector:@selector(wkScrollView:DidClickAtIndex:clickStyle:)])
    {
        [_wkVCDelegate wkScrollView:self DidClickAtIndex:sender.tag - BtnStartTag clickStyle:style];
        
        [self gotoOtherVCWithStyle:style index:sender.tag - BtnStartTag];
        
    }
    else if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(wkScrollView:DidClickAtIndex:clickStyle:)])
    {
        [_wkDelegate wkScrollView:self DidClickAtIndex:sender.tag - BtnStartTag clickStyle:style];
    }
    
    
}


- (void)gotoOtherVCWithStyle:(WKSelectImageViewBtnClickStyle)style index:(NSUInteger)tag
{
//    if ([_wkVCDelegate isMemberOfClass:[UIViewController class]]) {
    
    
        UIViewController * vc = nil;
        switch (style) {
            case WKSelectImageViewBtnClick_Add:
            {
                QTDynamicPhotoPickerViewController * controller=(QTDynamicPhotoPickerViewController*)[WKSBManager getVCWithSBName:@"Nearby" vcID:@"qtdynamicphotopicker"];
                controller.selectedImagesArr = [_selectImages mutableCopy];
                controller.maxImageCount = 9;
                NSLog(@"%@",_selectImages);
                vc = controller;
            }
                break;
            case WKSelectImageViewBtnClick_Look:
            {

            }
                break;
                
            default:
                break;
        }
        
        if (vc == nil) {
            return;
        }
        
        if (_wkVCDelegate.navigationController) {
            [_wkVCDelegate.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [_wkVCDelegate presentViewController:vc animated:YES completion:nil];
        }
//    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
