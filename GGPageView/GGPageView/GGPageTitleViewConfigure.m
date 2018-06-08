//
//  GGPageTitleViewConfigure.m
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGPageTitleViewConfigure.h"

@implementation GGPageTitleViewConfigure

- (instancetype)init{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    //弹性效果
    _needBounces = YES;
    //底部分割线
    _showBottomSeparator = YES;
    //指示器
    _showIndicator = YES;
}

+ (instancetype)pageTitleViewConfigure{
    return [[self alloc] init];
}

#pragma mark - GGPageTtileView属性
- (UIColor *)bottomSeparatorColor{
    if (!_bottomSeparatorColor) {
        _bottomSeparatorColor = [UIColor lightGrayColor];
    }
    return _bottomSeparatorColor;
}

#pragma mark - - 标题属性
- (UIFont *)titleFont{
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:15];
    }
    return _titleFont;
}

- (UIFont *)titleSelectedFont {
    if (!_titleSelectedFont) {
        _titleSelectedFont = [UIFont systemFontOfSize:15];
    }
    return _titleSelectedFont;
}

- (UIColor *)titleColor{
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (UIColor *)selectedTitleColor{
    if (!_selectedTitleColor) {
        _selectedTitleColor = [UIColor redColor];
    }
    return _selectedTitleColor;
}

- (CGFloat)titleTextScaling{
    if (_titleTextScaling <= 0) {
        _titleTextScaling = 0.3f;
    }else if (_titleTextScaling > 0.3){
        _titleTextScaling = 0.1f;
    }
    return _titleTextScaling;
}

- (CGFloat)spacingBetweenButtons{
    if (!_spacingBetweenButtons) {
        _spacingBetweenButtons = 20.0f;
    }
    return _spacingBetweenButtons;
}

#pragma mark - - 指示器属性
- (UIColor *)indicatorColor{
    if (!_indicatorColor) {
        _indicatorColor = [UIColor redColor];
    }
    return _indicatorColor;
}

- (CGFloat)indicatorHeight{
    if (_indicatorHeight <= 0) {
        _indicatorHeight = 2.0f;
    }
    return _indicatorHeight;
}

- (CGFloat)indicatorAnimationTime{
    if (_indicatorAnimationTime <= 0) {
        _indicatorAnimationTime = 0.1;
    }else if (_indicatorAnimationTime > 0.3){
        _indicatorAnimationTime = 0.3;
    }
    return _indicatorAnimationTime;
}

- (CGFloat)indicatorCornerRadius{
    if (_indicatorCornerRadius <= 0) {
        _indicatorCornerRadius = 0.0f;
    }
    return _indicatorCornerRadius;
}

- (CGFloat)indicatorToBottomDistance{
    if (_indicatorToBottomDistance <= 0) {
        _indicatorToBottomDistance = 0;
    }
    return _indicatorToBottomDistance;
}

- (CGFloat)indicatorBorderWidth{
    if (_indicatorBorderWidth <= 0) {
        _indicatorBorderWidth = 0;
    }
    return _indicatorBorderWidth;
}

- (UIColor *)indicatorBorderColor{
    if (!_indicatorBorderColor) {
        _indicatorBorderColor = [UIColor clearColor];
    }
    return _indicatorBorderColor;
}

- (CGFloat)indicatorAdditionalWidth{
    if (_indicatorAdditionalWidth <= 0) {
        _indicatorAdditionalWidth = 0;
    }
    return _indicatorAdditionalWidth;
}

- (CGFloat)indicatorFixedWidth{
    if (_indicatorFixedWidth <= 0) {
        _indicatorFixedWidth = 20;
    }
    return _indicatorFixedWidth;
}

- (CGFloat)indicatorDynamicWidth{
    if (_indicatorDynamicWidth <= 0) {
        _indicatorDynamicWidth = 20;
    }
    return _indicatorDynamicWidth;
}

#pragma mark - - 按钮之间分割线属性
- (UIColor *)verticalSeparatorColor {
    if (!_verticalSeparatorColor) {
        _verticalSeparatorColor = [UIColor redColor];
    }
    return _verticalSeparatorColor;
}

- (CGFloat)verticalSeparatorReduceHeight {
    if (_verticalSeparatorReduceHeight <= 0) {
        _verticalSeparatorReduceHeight = 0;
    }
    return _verticalSeparatorReduceHeight;
}

@end
