//
//  ViewController.m
//  二维码
//
//  Created by xiaofei on 2017/8/15.
//  Copyright © 2017年 xiaofei. All rights reserved.
//

#import "ViewController.h"
#import "NativeViewController.h"
#import "WebViewController.h"
#import "QRGetViewController.h"
#import "QRScanningViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy)NSArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"二维码";
    
    self.dataArray = @[@"在原生界面长按识别二维码", @"在web端长按识别二维码", @"二维码生成", @"二维码扫描"];
    [self.view addSubview:self.tableView];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - uitableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            NativeViewController *webVC = [[NativeViewController alloc] init];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:
        {
            WebViewController *webVC = [[WebViewController alloc] init];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            QRGetViewController *qrGetVc = [[QRGetViewController alloc] init];
            [self.navigationController pushViewController:qrGetVc animated:YES];
        }
            break;
        case 3:
        {
            QRScanningViewController *scanningVC = [[QRScanningViewController alloc] init];
            [self.navigationController pushViewController:scanningVC animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
