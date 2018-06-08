//
//  GGPageContentView.h
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPageContentView;
@protocol GGPageContentViewDelegate <NSObject>
@optional
/**
 *  联动 GGPageTitleView 的方法
 *
 *  @param pageContentView      self
 *  @param progress             self 内部视图滚动时的偏移量
 *  @param originalIndex        原始视图所在下标
 *  @param targetIndex          目标视图所在下标
 */
- (void)pageContentCollectionView:(GGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  根据偏移量来处理返回手势的问题
 *  @param offsetX     内部视图的偏移量
 */
- (void)pageContentView:(GGPageContentView *)pageContentView offsetX:(CGFloat)offsetX;
@end

@interface GGPageContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

+ (instancetype)pageContentCollectionViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

@property (nonatomic, weak) id <GGPageContentViewDelegate> delegatePageContentView;

/** 是否需要实现滚动，默认YES，NO时不需要实现self的代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/** 是否需要弹簧效果,默认YES */
@property (nonatomic, assign) BOOL isScrollBounces;

/** 给外界提供方法，显示下标对应的子控制器 */
- (void)setPageContentCollrctionViewCurrentIndex:(NSInteger)currentIndex;

@end
