//
//  QRScanningAnswerViewController.m
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "QRScanningAnswerViewController.h"

@interface QRScanningAnswerViewController ()

@property (nonatomic, strong)UILabel *answerLbl;

@end

@implementation QRScanningAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描结果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.scanStr.length) {
        self.answerLbl.text = self.scanStr;
    }
}

- (UILabel *)answerLbl {
    if (!_answerLbl) {
        _answerLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 300)];
        _answerLbl.numberOfLines = 0;
        [self.view addSubview:_answerLbl];
    }
    return _answerLbl;
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
