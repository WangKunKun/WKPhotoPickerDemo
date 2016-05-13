//
//  QTImagePickerController.m
//  QTRunningBang
//
//  Created by MacBook on 16/4/19.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKImagePickerController.h"
#import "WKWatermarkCameraView.h"
#import "WKCaptureImageView.h"

@interface WKImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WKWatermarkCameraView * watermarkCameraView;
@property (nonatomic, strong) WKCaptureImageView * captureView;


@end

@implementation WKImagePickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = WKImagePickerControllerModel_Default;
    }
    return self;
}

- (id)initWithModel:(WKImagePickerControllerModel)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    
//    self.showsCameraControls = _model;
    self.allowsEditing=YES;
    self.sourceType=UIImagePickerControllerSourceTypeCamera;


    self.delegate = self;

    
    
}

- (void)initWatermarkModel
{
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
    
    _captureView = [WKCaptureImageView viewFromNIB];
    _captureView.frame = self.cameraOverlayView.frame;
    _captureView.distance =  _distance;
    [_captureView setClick:^(NSUInteger tag, UIImage * image){
        switch (tag) {
            case 0:
                [weakSelf.captureView removeFromSuperview];
                break;
            case 1://OK
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                break;
            case 2://使用照片
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                //图片要传回去用代理
                if (weakSelf.wkImagePickerDelegate && [weakSelf.wkImagePickerDelegate respondsToSelector:@selector(takePhoto:)]) {
                    [weakSelf.wkImagePickerDelegate takePhoto:image];
                }
                break;

                break;
            default:
                break;
        }
    }];
    
    
        self.cameraOverlayView=_watermarkCameraView;
}

- (void)setModel:(WKImagePickerControllerModel)model
{
    _model = model;
    if (_model == WKImagePickerControllerModel_WaterMark) {
        [self initWatermarkModel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拍照回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage * temp = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.model == WKImagePickerControllerModel_WaterMark) {
        _captureView.mainImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
        _captureView.watemarkImage = _watermarkCameraView.saveImage;
        [self.view addSubview:_captureView];
    }
    else
    {

        [self dismissViewControllerAnimated:YES completion:nil];
        //图片要传回去用代理
        if (_wkImagePickerDelegate && [_wkImagePickerDelegate respondsToSelector:@selector(takePhoto:)]) {
            [_wkImagePickerDelegate takePhoto:temp];
        }
        
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
