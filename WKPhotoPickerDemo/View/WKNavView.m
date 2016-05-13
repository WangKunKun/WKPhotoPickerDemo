//
//  WKNavView.m
//  WKTimerTest
//
//  Created by MacBook on 16/4/28.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "WKNavView.h"

@interface WKNavView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation WKNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)viewFromNIB
{
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"WKNavView" owner:nil options:nil];
    WKNavView * nv = views[0];
    nv.isLeftBtnCanClick = YES;
    nv.isRightBtnCanClick = YES;
    return nv;
    
}


- (void)awakeFromNib
{
    self.widthS = SCREEN_WIDTH;
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;
    [_leftBtn setImage:leftImage forState:UIControlStateNormal];
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage = rightImage;
    [_rightBtn setImage:rightImage forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

- (IBAction)rightBtnClick:(UIButton *)sender {
    if (_isRightBtnCanClick && _wkNVDelegate && [_wkNVDelegate respondsToSelector:@selector(rightBtnClick:)]) {
        [_wkNVDelegate rightBtnClick:sender];
    }
}


- (IBAction)leftBtnClick:(UIButton *)sender {
    if (_isLeftBtnCanClick && _wkNVDelegate && [_wkNVDelegate respondsToSelector:@selector(leftBtnClick:)]) {
        [_wkNVDelegate leftBtnClick:sender];
    }
}


@end
