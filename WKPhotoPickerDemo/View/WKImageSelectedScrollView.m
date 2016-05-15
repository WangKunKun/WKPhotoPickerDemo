//
//  WKImageSelectedScroolView.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKImageSelectedScrollView.h"
#import "WKPhotoPickerViewController.h"

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
        selectImageView.originS = CGPointMake(startX, startY);
        [self addSubview:selectImageView];
        startX += selectImageView.widthS + space;
        [_btnArr addObject:selectImageView];
        selectImageView.wkDelegate = self;
        selectImageView.tag = BtnStartTag + i;
        i++;
        if (i >= _imagesMaxCount) {
            break;
        }
    }
  
    BOOL animationFlag = i == 0 ;
    CGFloat newStartX = animationFlag ? startX + SCREEN_WIDTH : startX;
    //添加最后的
    if (i < _imagesMaxCount) {
        
        
        
        WKSelectImageView * selectImageView = [WKSelectImageView viewFromNIB];
        selectImageView.originS =CGPointMake(newStartX, startY);
        [self addSubview:selectImageView];
        newStartX += selectImageView.widthS + space;
        selectImageView.tag = BtnStartTag + i;
        selectImageView.wkDelegate = self;
        [_btnArr addObject:selectImageView];
        
        if (animationFlag) {
            [UIView animateWithDuration:0.3 animations:^{
                selectImageView.originS = CGPointMake(startX, startY);
            }];
        }
        
        if (i == 0) {
            newStartX -= SCREEN_WIDTH;
        }
    }

    self.contentSize = CGSizeMake(newStartX, self.heightS);
    //执行动画
    
}

- (void)selectImageView:(WKSelectImageView *)sender style:(WKSelectImageViewBtnClickStyle)style
{

    switch (style) {
        case WKSelectImageViewBtnClick_Add:
        {
            
        }
            break;
        case WKSelectImageViewBtnClick_Look:
        {
            
        }
            break;
        case WKSelectImageViewBtnClick_Delete:
            
            //移除
            [_imagesM removeObjectAtIndex:sender.tag - BtnStartTag];
            self.images = [_imagesM copy];
            
            break;
    }
    
    
    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(wkScrollView:DidClickAtIndex:clickStyle:)])
    {
        [_wkDelegate wkScrollView:self DidClickAtIndex:sender.tag - BtnStartTag clickStyle:style];
    }
    
    
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
