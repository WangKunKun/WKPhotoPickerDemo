//
//  WKImageView.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKSelectImageView.h"

@interface WKSelectImageView ()

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIImageView *IV;

@end

@implementation WKSelectImageView



+ (instancetype)viewFromNIB
{
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"WKSelectImageView" owner:nil options:nil];
    WKSelectImageView * sv = views[0];
    sv.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:sv action:@selector(imageBtnClick:)];
    
    [sv.IV addGestureRecognizer:tap];
    
    return sv;

}

- (void)imageBtnClick:(UIGestureRecognizer *)sender {
    if (self.presentImage) {
        NSLog(@"查看图片");
        if(_wkDelegate && [_wkDelegate respondsToSelector:@selector(selectImageView:style:)])
        {
            [_wkDelegate selectImageView:self style:WKSelectImageViewBtnClick_Look];
        }
    }
    else
    {
        NSLog(@"进入相册");
        if(_wkDelegate && [_wkDelegate respondsToSelector:@selector(selectImageView:style:)])
        {
            [_wkDelegate selectImageView:self style:WKSelectImageViewBtnClick_Add];
        }
    }
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSLog(@"删除图片");
    if(_wkDelegate && [_wkDelegate respondsToSelector:@selector(selectImageView:style:)])
    {
        [_wkDelegate selectImageView:self style:WKSelectImageViewBtnClick_Delete];
    }
}

- (void)setPresentImage:(UIImage *)presentImage
{
    _presentImage = presentImage;
    _IV.image = _presentImage;
    _deleteBtn.hidden = presentImage == nil;
}

@end
