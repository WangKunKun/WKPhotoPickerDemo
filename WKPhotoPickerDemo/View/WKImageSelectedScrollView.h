//
//  WKImageSelectedScroolView.h
//  QTRunningBang
//
//  Created by MacBook on 16/4/22.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKSelectImageView.h"
@class WKImageSelectedScrollView;
@protocol WKImageSelectedScrollViewDelegate <NSObject>
@required
- (void)wkScrollView:(WKImageSelectedScrollView *)wkScrollView DidClickAtIndex:(NSUInteger)index clickStyle:(WKSelectImageViewBtnClickStyle)style;

@end

@interface WKImageSelectedScrollView : UIScrollView<UITableViewDelegate>

- (instancetype)initWithImages:(NSArray *)images frame:(CGRect)frame;

@property (nonatomic, assign) NSUInteger imagesMaxCount;

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) id<WKImageSelectedScrollViewDelegate> wkDelegate;
@property (nonatomic, assign) UIViewController <WKImageSelectedScrollViewDelegate> * wkVCDelegate;


@property (nonatomic, assign) NSArray <NSDictionary *>* selectImages;
@end
