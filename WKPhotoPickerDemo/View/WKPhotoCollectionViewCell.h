//
//  WKPhotoCollectionViewCell.h
//
//  Created by qitian on 15/11/18.
//  Copyright © 2015年 WangKunKun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKPhotoCollectionViewCellState_None = 2,
    WKPhotoCollectionViewCellState_Optional = 0,
    WKPhotoCollectionViewCellState_Selected = 1,
} WKPhotoCollectionViewCellState;

@interface WKPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) WKPhotoCollectionViewCellState wk_state;

@property (nonatomic, assign) BOOL isSelected;
@end
