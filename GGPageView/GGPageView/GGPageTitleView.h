//
//  GGPageTitleView.h
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPageTitleViewConfigure, GGPageTitleView;

typedef enum : NSUInteger{
    // 图片在左，文字在右
    GGImagePositionTypeDefault,
    // 图片在右，文字在左
    GGImagePositionTypeRight,
    // 图片在上，文字在下
    GGImagePositionTypeTop,
    // 图片在下，文字在上
    GGImagePositionTypeBottom,
} GGImagePositionType;

@protocol GGPageTitleViewDelegate <NSObject>
@optional
- (void)pageTitleView:(GGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex;
@end


@interface GGPageTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<GGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(GGPageTitleViewConfigure *)configure;

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<GGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(GGPageTitleViewConfigure*)configure;

/** 给外界提供方法获取progress/originalIndex/targetIndex 必须要实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/** 选中标题按钮下标，默认为 0 */
@property (nonatomic, assign) NSInteger selectedIndex;

/** 重置选中标题按钮下标（用于子控制器内的点击事件改变标题的选中下标）*/
@property (nonatomic, assign) NSInteger resetSelectedIndex;

/** 根据标题下标重置标题文字 */
- (void)resetTitle:(NSString *)title forIndex:(NSInteger)index;

/** 根据标题下标设置标题的 attributedTitle 属性 */
- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle selectedAttributedTitle:(NSMutableAttributedString *)selectedAttributedTitle forIndex:(NSInteger)index;

/**
 *  设置标题图片及位置样式
 *
 *  @param images       默认图片数组
 *  @param selectedImages       选中时图片数组
 *  @param imagePositionType       图片位置样式
 *  @param spacing      图片与标题文字之间的间距
 */
- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectedImages imagePositionType:(GGImagePositionType)imagePositionType spacing:(CGFloat)spacing;
@end
