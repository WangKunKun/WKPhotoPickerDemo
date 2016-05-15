//
//  WKPhotoBrowseVC.m
//  WKPhotoPickerDemo
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "WKPhotoBrowseVC.h"
#import "WKNavView.h"


@interface WKPhotoBrowseVC ()<WKNavViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) WKNavView * nav;

@property (nonatomic, strong) NSArray * images;

@property (nonatomic, assign) NSUInteger currentIndex;



@end

@implementation WKPhotoBrowseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nav = [WKNavView viewFromNIB];
    _nav.leftTitle = @"返回";
    _nav.originS = CGPointMake(0, 0);
    [self.view addSubview:_nav];
    _nav.wkNVDelegate = self;
    _nav.backgroundColor = [_nav.backgroundColor colorWithAlphaComponent:0.5];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    self.currentIndex = 0;
    
    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(imagesOfSource)]) {
        _images = [[_wkDelegate imagesOfSource] mutableCopy];
    }
    
    if (_wkDelegate && [_wkDelegate respondsToSelector:@selector(currentIndexOfImages)]) {
        self.currentIndex  = [_wkDelegate currentIndexOfImages];
    }
    
    

//    _nav.title = [NSString stringWithFormat:@"%lu/%lu",_currentIndex,_images.count];

    UILongPressGestureRecognizer * longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(wkTouch:)];
    [self.view addGestureRecognizer:longpress];

    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wkTouch:)];
    [self.view addGestureRecognizer:tap];
    
    [tap requireGestureRecognizerToFail:longpress];
    
    CGFloat startX = 0;
    CGFloat startY = 0;
    
    NSUInteger i = 0;
    for (UIImage * image in _images) {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, SCREEN_WIDTH, _scrollView.heightS)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = image;
        [self.scrollView addSubview:iv];
        iv.userInteractionEnabled = YES;


        startX += SCREEN_WIDTH;
        i++;
    }
    _scrollView.contentSize = CGSizeMake(startX, _scrollView.heightS);
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * _currentIndex, 0);
    
    
    [self.view bringSubviewToFront:_nav];
}

- (void)wkTouch:(UIGestureRecognizer *)tap
{
    if ([tap isKindOfClass:[UITapGestureRecognizer class]]) {
        [_nav show:_nav.hidden];

    }
    else
    {
        NSLog(@"长按");
        //获得图片，保存？
        UIImage * image = _images[_currentIndex];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.currentIndex = page;
    

}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    _nav.title = [NSString stringWithFormat:@"%lu/%lu",_currentIndex + 1,_images.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtnClick:(UIButton *)btn
{
    if (self.navigationController != nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
