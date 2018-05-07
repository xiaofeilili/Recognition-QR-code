//
//  QRScanningViewController.m
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "QRScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRScanningAnswerViewController.h"

#define kWidth      [UIScreen mainScreen].bounds.size.width
#define kHeight     [UIScreen mainScreen].bounds.size.height

#define rectangleX      (kWidth - 200)/2
#define rectangleY      100
#define rectangleW      200
#define rectangleH      200

@interface QRScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong)UIView *inView;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong)AVCaptureSession *session;

@end

@implementation QRScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPath];
    
    [self setupScanningQRCode];
}

- (void)setupPath {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.view.bounds;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, kHeight)];
    [bezierPath addLineToPoint:CGPointMake(kWidth, kHeight)];
    [bezierPath addLineToPoint:CGPointMake(kWidth, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];

    [bezierPath addLineToPoint:CGPointMake(rectangleX, rectangleY)];
    [bezierPath addLineToPoint:CGPointMake(rectangleX + rectangleW, rectangleY)];
    [bezierPath addLineToPoint:CGPointMake(rectangleX + rectangleW, rectangleY + rectangleH)];
    [bezierPath addLineToPoint:CGPointMake(rectangleX, rectangleY + rectangleH)];
    [bezierPath addLineToPoint:CGPointMake(rectangleX, rectangleY)];
    
    [bezierPath closePath];
    [bezierPath fill];

    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(162.5, 600, 50, 50);
    flashBtn.backgroundColor = [UIColor brownColor];
//    flashBtn.selected = NO;
    [flashBtn addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
}

- (void)flashBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

- (void)setupScanningQRCode {
    // 1.获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2.创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 3.创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 4. 设置代理  在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置扫描范围（每个取值0~1， 以屏幕右上角为坐标原点，往下为x增，往左为y增，宽高和一般的互换了）
//    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    /**
     * 0.5 0 0.5 0.5   右下角
     * 0 0.5 0.5 0.5   左上角
     * 0 0 0.5 0.5     右上角
     * 0.5 0.5 0.5 0.5 左下角*/
    output.rectOfInterest = CGRectMake(rectangleY/kHeight, rectangleX/kWidth, rectangleH/kHeight, rectangleW/kWidth);
    
    // 5.初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 5.1 添加会话输入
    [_session addInput:input];
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6. 设置输出数据类型，需要将元数据输出添加到会话后，才能制定元数据类型，否则会报错
    // 设置扫描支付的编码格式（如下设置条形码和二维码兼容）
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // 7. 实例化预览图层，传递_session 是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    // 8. 将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    // 9. 启动会话
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count]) {
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects[0];
        NSLog(@"%@", metadataObj);
        [_session stopRunning];
        
        QRScanningAnswerViewController *answerVC = [[QRScanningAnswerViewController alloc] init];
        answerVC.scanStr = [metadataObj stringValue];
        [self.navigationController pushViewController:answerVC animated:YES];
    }else {
        NSLog(@"没有识别");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
