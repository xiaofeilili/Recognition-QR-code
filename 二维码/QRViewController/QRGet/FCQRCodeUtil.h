//
//  FCQRCodeUtil.h
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MessageBlock)(NSString *message);
typedef void(^WebQRInfoBlock)(NSString *message, NSString *imageUrl);
typedef void(^NoneBlock)(void);

@interface FCQRCodeUtil : NSObject
/**
 * 生成二维码
 *
 * @param string 要生成二维码的目标字符串
 * @param sizewidth 图片尺寸
 *
 * return UIImage 图片
 */
+ (UIImage *)createQRCodeImageString:(NSString *)string size:(CGFloat)sizewidth;

+ (void)recognizeQRCodeInNativeView:(UIView *)view messageBlock:(MessageBlock)messageBlock;

+ (void)recognizeQRCodeInWebView:(UIWebView *)webView TapGesture:(UITapGestureRecognizer *)recognizer messageBlock:(WebQRInfoBlock)messageBlock noneImageBlock:(NoneBlock)noneBlock;

@end
