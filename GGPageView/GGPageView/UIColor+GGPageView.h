//
//  UIColor+GGPageView.h
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GGPageView)
/** 随机色 */
+ (UIColor *)randomColor;

/** RGB生成颜色 */
+ (instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

/** 32位色 */
+ (UIColor *)ColorWithHexString:(NSString *)hexString;

/**
 从颜色重获取RGB
 @return CGFloat数据数组
 */
- (NSArray <NSNumber *> *)getNomalRGB;
@end
