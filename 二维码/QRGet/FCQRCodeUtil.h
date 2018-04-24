//
//  FCQRCodeUtil.h
//  二维码
//
//  Created by 李晓飞 on 2018/4/24.
//  Copyright © 2018年 xiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCQRCodeUtil : NSObject

+ (UIImage *)createQRCodeImageString:(NSString *)string size:(CGFloat)sizewidth;

@end
