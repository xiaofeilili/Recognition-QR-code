//
//  FCQRCodeUtil.m
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import "FCQRCodeUtil.h"

@implementation FCQRCodeUtil

+ (UIImage *)createQRCodeImageString:(NSString *)string size:(CGFloat)sizewidth {
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = string;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    return [FCQRCodeUtil createNonInterpolatedUIImageFormCIImage:outputImage withSize:sizewidth];//重绘二维码,使其显示清晰
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (void)recognizeQRCodeInNativeView:(UIView *)view messageBlock:(MessageBlock)messageBlock {
    //截图 再读取
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //识别二维码
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    NSArray *features = [detector featuresInImage:ciImage];
    for (CIQRCodeFeature *feature in features) {
        NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
        !messageBlock ? : messageBlock(feature.messageString);
    }
}

+ (void)recognizeQRCodeInWebView:(UIWebView *)webView TapGesture:(UITapGestureRecognizer *)recognizer messageBlock:(WebQRInfoBlock)messageBlock noneImageBlock:(NoneBlock)noneBlock {
    CGPoint touchPoint = [recognizer locationInView:webView];
    
    // 通过长按触点识别该触点是否有二维码
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *imageUrl = [webView stringByEvaluatingJavaScriptFromString:js];
    if (imageUrl.length == 0) {
        !noneBlock ? : noneBlock();
        return;
    }
    NSLog(@"image url：%@",imageUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        //识别二维码
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
        NSArray *features = [detector featuresInImage:ciImage];
        
        NSString *message;
        //        for (CIQRCodeFeature *feature in features) {
        //            NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
        //
        //        }
        CIQRCodeFeature *feature = features[0];
        message = feature.messageString;
        
        !messageBlock ? : messageBlock(message, imageUrl);
    }
}

@end
