//
//  ViewController.m
//  二维码
//
//  Created by xiaofei on 2017/8/15.
//  Copyright © 2017年 xiaofei. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"二维码";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"网页"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(nextView)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo"]];
    imgView.frame = CGRectMake(100, 100, 100, 100);
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    //长按识别图中的二维码，类似于微信里面的功能,前提是当前页面必须有二维码
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readCode:)];
//    [self.view addGestureRecognizer:longPress];
    [imgView addGestureRecognizer:longPress];
}
// 到网页
- (void)nextView {
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
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
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
