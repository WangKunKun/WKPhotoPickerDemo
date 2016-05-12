//
//  QTDynamicPhotoPickerViewController.h
//  QTRunningBang
//
//  Created by qitian on 15/11/17.
//  Copyright © 2015年 qitianxiongdi. All rights reserved.
//

#import <UIKit/UIKit.h>


//进入此VC的VC必须包含
@interface QTDynamicPhotoPickerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectedConterLabel;

@property (nonatomic, strong) NSMutableArray * selectedImagesArr;

@property (nonatomic) NSUInteger maxImageCount;
@end
