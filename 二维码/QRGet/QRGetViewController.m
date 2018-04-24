//
//  QRGetViewController.m
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "QRGetViewController.h"
#import "FCQRCodeUtil.h"

@interface QRGetViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *textfield;        // 需要生成二维码的字符串
@property (nonatomic, strong)UIButton *getButton;           // 生成按钮
@property (nonatomic, strong)UIImageView *qrImgView;        // 生成的二维码

@end

@implementation QRGetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生成二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.textfield];
    [self.view addSubview:self.getButton];
    [self.view addSubview:self.qrImgView];
}

- (void)getButtonClick {
    self.qrImgView.image = [FCQRCodeUtil createQRCodeImageString:self.textfield.text size:self.qrImgView.frame.size.width];
}

#pragma mark - lazy load UI
- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
        _textfield.delegate = self;
        _textfield.layer.borderColor = [UIColor cyanColor].CGColor;
        _textfield.layer.borderWidth = 1.0f;
        _textfield.layer.cornerRadius = 3;
    }
    return _textfield;
}

- (UIButton *)getButton {
    if (!_getButton) {
        _getButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _getButton.frame = CGRectMake(160, 180, 80, 40);
        _getButton.layer.cornerRadius = 3;
        [_getButton setTitle:@"生成" forState:UIControlStateNormal];
        [_getButton setBackgroundColor:[UIColor brownColor]];
        [_getButton addTarget:self action:@selector(getButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getButton;
}

- (UIImageView *)qrImgView {
    if (!_qrImgView) {
        _qrImgView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 280, 140, 140)];
        _qrImgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _qrImgView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
