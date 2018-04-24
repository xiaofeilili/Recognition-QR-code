//
//  NativeViewController.m
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "NativeViewController.h"

@interface NativeViewController ()

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo"]];
    imgView.frame = CGRectMake(100, 100, 100, 100);
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    //长按识别图中的二维码，类似于微信里面的功能,前提是当前页面必须有二维码
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readCode:)];
    //    [self.view addGestureRecognizer:longPress];
    [self.view addGestureRecognizer:longPress];
}

// 长按识别
- (void)readCode:(UILongPressGestureRecognizer *)pressSender {
    if (pressSender.state == UIGestureRecognizerStateBegan) {
        //截图 再读取
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //识别二维码
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
        NSArray *features = [detector featuresInImage:ciImage];
        for (CIQRCodeFeature *feature in features) {
            NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"结果" message:[NSString stringWithFormat:@"您的二维码识别结果是：%@", feature.messageString] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
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
