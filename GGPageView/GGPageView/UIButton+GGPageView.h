//
//  UIButton+GGPageView.h
//  GGPageView
//
//  Created by Mac on 2018/6/4.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    /// 图片在左，文字在右
    GGImagePositionStyleDefault,
    /// 图片在右，文字在左
    GGImagePositionStyleRight,
    /// 图片在上，文字在下
    GGImagePositionStyleTop,
    /// 图片在下，文字在上
    GGImagePositionStyleBottom,
} GGImagePositionStyle;
@interface UIButton (GGPageView)
/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)GG_imagePositionStyle:(GGImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;
@end
