//
//  ViewController.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/12.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "ViewController.h"
#import "WKImageSelectedScrollView.h"
#import "WKPhotoPickerViewController.h"

#import "WKPhotoManager.h"
@interface ViewController ()<WKImageSelectedScrollViewDelegate>
@property (nonatomic, strong) WKImageSelectedScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray * waitingActionImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    _waitingActionImages = [NSMutableArray array];
    _scrollView = [[WKImageSelectedScrollView alloc] initWithImages:nil frame:CGRectMake(0, 200, SCREEN_WIDTH, 200)];
    [self.view addSubview:_scrollView];
    _scrollView.wkDelegate = self;

}


- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedImages) {
        [_waitingActionImages removeAllObjects];
        for (NSDictionary * dict in self.selectedImages) {
            [_waitingActionImages addObjectsFromArray:[dict allValues]];
        }
        _scrollView.images = self.waitingActionImages ;

    }
    
}


- (void)wkScrollView:(WKImageSelectedScrollView *)wkScrollView DidClickAtIndex:(NSUInteger)index clickStyle:(WKSelectImageViewBtnClickStyle)style
{
    switch (style) {
        case WKSelectImageViewBtnClick_Delete:
            [_waitingActionImages removeObjectAtIndex:index];
            [self.selectedImages removeObjectAtIndex:index];
            break;
        case WKSelectImageViewBtnClick_Add:
        {
            WKPhotoPickerViewController * vc = [[WKPhotoPickerViewController alloc] init];
            vc.selectedImages = self.selectedImages;
            [self presentViewController:vc animated:YES completion:nil];
        }
            
            break;
        case WKSelectImageViewBtnClick_Look:
        {
            
        }
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
