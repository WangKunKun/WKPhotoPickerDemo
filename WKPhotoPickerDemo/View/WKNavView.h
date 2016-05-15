//
//  WKNavView.h
//  WKTimerTest
//
//  Created by MacBook on 16/4/28.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKNavViewDelegate <NSObject>


@optional
- (void)leftBtnClick:(UIButton *)btn;
- (void)rightBtnClick:(UIButton *)btn;

@end

@interface WKNavView : UIView

+ (instancetype)viewFromNIB;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * leftTitle;
@property (nonatomic, strong) UIImage * leftImage;

@property (nonatomic, strong) NSString * rightTitle;
@property (nonatomic, strong) UIImage * rightImage;

@property (nonatomic, assign) BOOL isLeftBtnCanClick;
@property (nonatomic, assign) BOOL isRightBtnCanClick;

@property (nonatomic, assign) id<WKNavViewDelegate> wkNVDelegate;

- (void)show:(BOOL)flag;

@end
