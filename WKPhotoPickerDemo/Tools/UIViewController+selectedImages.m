//
//  UIViewController+selectedImages.m
//  WKPhotoPickerDemo
//
//  Created by qitian on 16/5/13.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "UIViewController+selectedImages.h"
#import <objc/runtime.h>

@implementation UIViewController (selectedImages)

- (NSMutableArray *)selectedImages {
    return objc_getAssociatedObject(self, @selector(selectedImages));
}

- (void)setSelectedImages:(NSMutableArray *)selectedImages {
    objc_setAssociatedObject(self, @selector(selectedImages), selectedImages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
