//
//  GGPageTitleViewConfigure.h
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum :NSUInteger{
    /// 下划线样式
    GGIndicatorStyleDefault,
    /// 遮盖样式
    GGIndicatorStyleCover,
    /// 固定样式
    GGIndicatorStyleFixed,
    /// 动态样式（仅在 GGIndicatorScrollStyleDefault 样式下支持）
    GGIndicatorStyleDynamic
}GGIndicatorStyle;

typedef enum :NSUInteger{
    /// 指示器位置跟随内容滚动而改变
    GGIndicatorScrollStyleDefault,
    /// 内容滚动一半时指示器位置改变
    GGIndicatorScrollStyleHalf,
    /// 内容滚动结束时指示器位置改变
    GGIndicatorScrollStyleEnd
} GGIndicatorScrollStyle;

@interface GGPageTitleViewConfigure : NSObject

+ (instancetype)pageTitleViewConfigure;

#pragma mark - - GGPageTitleView 属性
/** 弹性效果,默认YES */
@property (nonatomic, assign) BOOL needBounces;
/** 显示底部分割线,默认YES */
@property (nonatomic, assign) BOOL showBottomSeparator;
/** 分割线颜色,默认lightGrayColor */
@property (nonatomic, strong) UIColor *bottomSeparatorColor;

#pragma mark - - 标题属性
/** 普通titleFont,默认15 */
@property (nonatomic, strong) UIFont *titleFont;
/** 选中titleFont,默认15 */
@property (nonatomic, strong) UIFont *titleSelectedFont;
/** 普通titleColor,默认黑色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 选中titleColor, 默认红色 */
@property (nonatomic, strong) UIColor *selectedTitleColor;
/** 按钮标题渐变效果,默认NO */
@property (nonatomic, assign) BOOL titleGradientEffect;
/** 按钮标题缩放效果,默认NO */
@property (nonatomic, assign) BOOL titleTextZoom;
/** 按钮标题文字缩放比,默认0.1f，范围0~0.3f */
@property (nonatomic, assign) CGFloat titleTextScaling;
/** 按钮间距 默认20.f */
@property (nonatomic, assign) CGFloat spacingBetweenButtons;

#pragma mark - - 指示器属性
/** 是否显示指示器,默认YES */
@property (nonatomic, assign) BOOL showIndicator;
/** 指示器颜色,默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 指示器高度,默认，2f */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** 指示器动画时间，默认0.1f，0~0.3f */
@property (nonatomic, assign) CGFloat indicatorAnimationTime;
/** 指示器样式 */
@property (nonatomic, assign) GGIndicatorStyle indicatorStyle;
/** 指示器圆角大小,默认0f */
@property (nonatomic, assign) CGFloat indicatorCornerRadius;
/** 指示器遮盖样式外的其他样式下指示器与底部之间的距离，默认为 0f */
@property (nonatomic, assign) CGFloat indicatorToBottomDistance;
/** 指示器遮盖样式下的边框宽度，默认为 0.0f */
@property (nonatomic, assign) CGFloat indicatorBorderWidth;
/** 指示器遮盖样式下的边框颜色，默认为 clearColor */
@property (nonatomic, strong) UIColor *indicatorBorderColor;
/** 指示器遮盖、下划线样式下额外增加的宽度，默认为 0.0f；介于标题文字宽度与按钮宽度之间 */
@property (nonatomic, assign) CGFloat indicatorAdditionalWidth;
/** 指示器固定样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置 */
@property (nonatomic, assign) CGFloat indicatorFixedWidth;
/** 指示器动态样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置 */
@property (nonatomic, assign) CGFloat indicatorDynamicWidth;
/** 指示器滚动位置改变样式，默认为 GGIndicatorScrollStyleDefault */
@property (nonatomic, assign) GGIndicatorScrollStyle indicatorScrollStyle;

#pragma mark - - 按钮之间分割线属性
/** 是否显示按钮之间的分割线，默认为 NO */
@property (nonatomic, assign) BOOL showVerticalSeparator;
/** 按钮之间的分割线颜色，默认为红色 */
@property (nonatomic, strong) UIColor *verticalSeparatorColor;
/** 按钮之间的分割线额外减少的高度，默认为 0.0f */
@property (nonatomic, assign) CGFloat verticalSeparatorReduceHeight;

@end
