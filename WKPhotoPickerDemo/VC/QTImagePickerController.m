//
//  QTImagePickerController.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "QTImagePickerController.h"
#import "WKWatermarkCameraView.h"
#import "WKCaptureImageView.h"
#import "WKThirdShareView.h"
#import "QTRunningViewController.h"

@interface QTImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WKWatermarkCameraView * watermarkCameraView;
@property (nonatomic, strong) WKCaptureImageView * captureView;


@end

@implementation QTImagePickerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sourceType=UIImagePickerControllerSourceTypeCamera;
    self.delegate=self;
    self.showsCameraControls=NO;
    self.allowsEditing=YES;
    //iOS8 以上才有
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    _watermarkCameraView = [WKWatermarkCameraView viewFromNIB];
    _watermarkCameraView.frame=self.cameraOverlayView.frame;
    _watermarkCameraView.distance = _distance;
    WEAKSELF
    [_watermarkCameraView setClick:^(NSUInteger tag,BOOL selected){
        NSLog(@"%lu",tag);
        switch (tag) {
            case 0:
                weakSelf.cameraFlashMode = selected ? UIImagePickerControllerCameraFlashModeOn :UIImagePickerControllerCameraFlashModeOff;
                break;
            case 1:
                weakSelf.cameraDevice = selected ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
            
                break;
            case 2:
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                break;
            case 3:
            {
                [weakSelf takePicture];
            }
                break;
            default:
                break;
        }
    }];
    //覆盖view
    self.cameraOverlayView=_watermarkCameraView;
    
    _captureView = [WKCaptureImageView viewFromNIB];
    _captureView.frame = self.cameraOverlayView.frame;
    _captureView.distance =  _distance;
    [_captureView setClick:^(NSUInteger tag, UIImage * image){
        switch (tag) {
            case 0:
                [weakSelf.captureView removeFromSuperview];
                break;
            case 1:
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                break;
            case 2:
                //分享
            {
                UIViewController * vc = weakSelf.presentingViewController;
                QTRunningViewController * temp = nil;
                if ([vc isKindOfClass:[UINavigationController class]]) {
                    UINavigationController * nav = (UINavigationController *)vc;
                    temp = nav.viewControllers[0];
                }
                else if([vc isKindOfClass:[QTRunningViewController class]])
                {
                    temp = (QTRunningViewController *)vc;
                }
                
                temp.gotoModel = WKRunningVCGoToPublishDynamicVC;
                temp.saveImage = weakSelf.captureView.saveImage;
                NSLog(@"ttttt %@",temp);
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            }
                break;
            default:
                break;
        }
    }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拍照回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _captureView.mainImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
    _captureView.watemarkImage = _watermarkCameraView.saveImage;
    [self.view addSubview:_captureView];
    
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
