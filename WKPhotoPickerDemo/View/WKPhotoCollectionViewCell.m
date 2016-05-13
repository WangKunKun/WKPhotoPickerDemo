//
//  WKPhotoCollectionViewCell.m
//
//  Created by qitian on 15/11/18.
//  Copyright © 2015年 WangKunKun. All rights reserved.
//

#import "WKPhotoCollectionViewCell.h"

@interface WKPhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedIV;

@property (weak, nonatomic) IBOutlet UIImageView *IV;
@end


@implementation WKPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setWk_state:(WKPhotoCollectionViewCellState)wk_state
{
    _wk_state = wk_state;
    switch (wk_state) {
        case WKPhotoCollectionViewCellState_None:
            _selectedIV.hidden = YES;
            _IV.image = GET_IMAGE(@"拍照@2x.png");
            break;
        case WKPhotoCollectionViewCellState_Optional:

            _selectedIV.hidden = YES;
            break;
        case WKPhotoCollectionViewCellState_Selected:
            _selectedIV.hidden = NO;

            break;
        default:
            break;
    }
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    _IV.image = image;
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.wk_state = isSelected == YES ? WKPhotoCollectionViewCellState_Selected : WKPhotoCollectionViewCellState_Optional;
    
}

@end
