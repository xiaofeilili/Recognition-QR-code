//
//  WebViewController.m
//  二维码
//
//  Created by xiaofei on 2017/8/15.
//  Copyright © 2017年 xiaofei. All rights reserved.
//

#import "WebViewController.h"
#import "FCQRCodeUtil.h"

@interface WebViewController ()<UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.bangbanglicai.com/static/mobile/recommend/recommend.html"]];
    
    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"webQRDemo.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:pathUrl];
    [self.webView loadRequest:request];
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.webView addGestureRecognizer:longPressed];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

- (void)longPressed:(UITapGestureRecognizer*)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    __weak typeof(self)wSelf = self;
    [FCQRCodeUtil recognizeQRCodeInWebView:self.webView TapGesture:recognizer messageBlock:^(NSString *message, NSString *imageUrl) {
        [wSelf dealQRCodeWithMessage:message imageURL:imageUrl];
    } noneImageBlock:^{
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"结果" message:@"没有识别到二维码，请确保手指点击在二维码范围内" preferredStyle:UIAlertControllerStyleAlert];
        [alert2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert2 animated:YES completion:nil];
    }];
}

- (void)dealQRCodeWithMessage:(NSString *)message imageURL:(NSString *)imageUrl {
    //......
    //保存图片至相册
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    }];
    UIAlertAction *regAction = [UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"结果" message:[NSString stringWithFormat:@"您的二维码识别结果是：%@", message] preferredStyle:UIAlertControllerStyleAlert];
        [alert2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert2 animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:regAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
