//
//  NativeViewController.m
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "NativeViewController.h"
#import "FCQRCodeUtil.h"

@interface NativeViewController ()

@property (nonatomic, strong)UIImageView *imgView;

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo"]];
    self.imgView.frame = CGRectMake(100, 100, 100, 100);
    self.imgView.userInteractionEnabled = YES;
    [self.view addSubview:self.imgView];
    
    //长按识别图中的二维码，类似于微信里面的功能,前提是当前页面必须有二维码
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readCode:)];
    //    [self.view addGestureRecognizer:longPress];
    [self.view addGestureRecognizer:longPress];
}

// 长按识别
- (void)readCode:(UILongPressGestureRecognizer *)pressSender {
    if (pressSender.state == UIGestureRecognizerStateBegan) {
        [self dealQRCode];
    }
}
// 处理二维码，选择是保存还是识别
- (void)dealQRCode {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, nil, NULL);
    }];
    UIAlertAction *regAction = [UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self recoginizeQRCode];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:regAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
// 识别二维码
- (void)recoginizeQRCode {
    __weak typeof(self)wSelf = self;
    [FCQRCodeUtil recognizeQRCodeInNativeView:self.view messageBlock:^(NSString *message) {
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"结果" message:[NSString stringWithFormat:@"您的二维码识别结果是：%@", message] preferredStyle:UIAlertControllerStyleAlert];
        [alert2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [wSelf presentViewController:alert2 animated:YES completion:nil];
    }];
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
