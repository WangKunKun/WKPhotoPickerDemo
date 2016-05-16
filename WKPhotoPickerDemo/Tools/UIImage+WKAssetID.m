//
//  UIImage+WKAssetID.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/16.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "UIImage+WKAssetID.h"
#import <objc/runtime.h>

@implementation UIImage (WKAssetID)



- (NSString *)wk_assetID {
    return objc_getAssociatedObject(self, @selector(wk_assetID)) ;
}

- (void)setWk_assetID:(NSString *)wk_assetID {
    objc_setAssociatedObject(self, @selector(wk_assetID), wk_assetID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)wk_index {
    return objc_getAssociatedObject(self, @selector(wk_index)) ;
}

- (void)setWk_index:(NSString *)wk_index {
    objc_setAssociatedObject(self, @selector(wk_index), wk_index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)wk_isEqualToImage:(UIImage *)image
{
    return [self.wk_assetID isEqualToString:image.wk_assetID];
}

@end
