//
//  WKCaptureImageView.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//
#define BtnTag 100
#import "WKCaptureImageView.h"
@interface WKCaptureImageView ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *waterMarkIV;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *captureView;

@end


@implementation WKCaptureImageView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)viewFromNIB
{
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"WKCaptureImageView" owner:nil options:nil];
    return views[0];
}


- (IBAction)sender:(UIButton *)sender {
    
    if (_saveImage == nil) {
        UIImage * image = [UIImage getTargetViewScreenShotImageWithView:_captureView];
        _saveImage = image;
    }

    
    if (sender.tag == 101 || sender.tag == 102) {
    //ok按钮
//    UIImageWriteToSavedPhotosAlbum(_saveImage, nil, nil, nil);
    
    //把截图保存到相册
    }
    
    if (self.click) {
        self.click(sender.tag - BtnTag,_saveImage);
    }
}

- (void)setDistance:(CGFloat)distance
{
    _distance = distance;
    _logoLabel.text = [NSString stringWithFormat:@"%.2lf Km",distance/ 1000.0];
}

- (void)setMainImage:(UIImage *)mainImage
{
    _mainImage = mainImage;
    _mainImageView.image = mainImage;
}

- (void)setWatemarkImage:(UIImage *)watemarkImage
{
    _watemarkImage = watemarkImage;
    _waterMarkIV.image = watemarkImage;
    _logoView.hidden = _watemarkImage == nil;

}



@end
