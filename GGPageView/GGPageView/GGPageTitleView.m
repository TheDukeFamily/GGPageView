//
//  GGPageTitleView.m
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGPageTitleView.h"
#import "UIView+GGPageView.h"
#import "UIButton+GGPageView.h"
#import "UIColor+GGPageView.h"
#import "GGPageTitleViewConfigure.h"

@interface GGPageTitleView ()
@property (nonatomic, weak) id <GGPageTitleViewDelegate> delegatePageTitleView;
@property (nonatomic, strong) GGPageTitleViewConfigure *configure;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *bottomSeparator;
/** 存储标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 存储按钮数组 */
@property (nonatomic, strong) NSMutableArray *btnArr;
/** 临时Btn */
@property (nonatomic, strong) UIButton *tempBtn;
/// 记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
/// 记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;
/// 标记按钮下标
@property (nonatomic, assign) NSInteger signBtnIndex;
/// 开始颜色, 取值范围 0~1
@property(nonatomic, strong) NSArray <NSNumber *> * startRGB;
/// 完成颜色, 取值范围 0~1
@property(nonatomic, strong) NSArray <NSNumber *> * endRGB;
@end

@implementation GGPageTitleView

#pragma mark - - - lazy load
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        if (_configure.needBounces == NO) {
            _scrollView.bounces = NO;
        }
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        if (self.configure.indicatorStyle == GGIndicatorStyleCover) {
            CGFloat tempIndicatorViewH = [self GG_heightWithString:[self.btnArr[0] currentTitle] font:self.configure.titleFont];
            if (self.configure.indicatorHeight > self.height) {
                _indicatorView.y = 0;
                _indicatorView.height = self.height;
            } else if (self.configure.indicatorHeight < tempIndicatorViewH) {
                _indicatorView.y = 0.5 * (self.height - tempIndicatorViewH);
                _indicatorView.height = tempIndicatorViewH;
            } else {
                _indicatorView.y = 0.5 * (self.height - self.configure.indicatorHeight);
                _indicatorView.height = self.configure.indicatorHeight;
            }
            
            // 边框宽度及边框颜色
            _indicatorView.layer.borderWidth = self.configure.indicatorBorderWidth;
            _indicatorView.layer.borderColor = self.configure.indicatorBorderColor.CGColor;
            
        } else {
            CGFloat indicatorViewH = self.configure.indicatorHeight;
            _indicatorView.height = indicatorViewH;
            _indicatorView.y = self.height - indicatorViewH - self.configure.indicatorToBottomDistance;
        }
        // 圆角处理
        if (self.configure.indicatorCornerRadius > 0.5 * _indicatorView.height) {
            _indicatorView.layer.cornerRadius = 0.5 * _indicatorView.height;
        } else {
            _indicatorView.layer.cornerRadius = self.configure.indicatorCornerRadius;
        }
        
        _indicatorView.backgroundColor = self.configure.indicatorColor;
    }
    return _indicatorView;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] init];
        CGFloat bottomSeparatorW = self.width;
        CGFloat bottomSeparatorH = 0.5;
        CGFloat bottomSeparatorX = 0;
        CGFloat bottomSeparatorY = self.height - bottomSeparatorH;
        _bottomSeparator.frame = CGRectMake(bottomSeparatorX, bottomSeparatorY, bottomSeparatorW, bottomSeparatorH);
        _bottomSeparator.backgroundColor = self.configure.bottomSeparatorColor;
    }
    return _bottomSeparator;
}
#pragma mark - - - set
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    if (selectedIndex) {
        _selectedIndex = selectedIndex;
    }
}

- (void)setResetSelectedIndex:(NSInteger)resetSelectedIndex{
    _resetSelectedIndex = resetSelectedIndex;
    [self gg_btn_cilck:self.btnArr[resetSelectedIndex]];
}

#pragma mark - - - 初始化
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<GGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(GGPageTitleViewConfigure *)configure{
    if (self = [super initWithFrame:frame]) {
        if (delegate == nil) @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 初始化方法中的代理必须设置" userInfo:nil];
        if (titleNames == nil) @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 初始化方法中的标题数组必须设置" userInfo:nil];
        if (configure == nil) @throw [NSException exceptionWithName:@"SGPagingView" reason:@"SGPageTitleView 初始化方法中的配置信息必须设置" userInfo:nil];

        self.delegatePageTitleView = delegate;
        self.titleArr = titleNames;
        self.configure = configure;

        //默认选中第一个按钮
        _selectedIndex = 0;

        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<GGPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(GGPageTitleViewConfigure *)configure{
    return [[self alloc] initWithFrame:frame delegate:delegate titleNames:titleNames configure:configure];
}


#pragma mark - - - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 选中按钮下标初始值
    UIButton *lastBtn = self.btnArr.lastObject;
    if (lastBtn.tag >= _selectedIndex && _selectedIndex >= 0) {
        [self gg_btn_cilck:self.btnArr[_selectedIndex]];
    } else {
        return;
    }
}

- (void)setupSubviews {
    // 0、处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    // 1、添加 UIScrollView
    [self addSubview:self.scrollView];
    // 2、添加标题按钮
    [self setupTitleButtons];
    // 3、添加底部分割线
    if (self.configure.showBottomSeparator == YES) {
        [self addSubview:self.bottomSeparator];
    }
    // 4、添加指示器
    if (self.configure.showIndicator == YES) {
        [self.scrollView insertSubview:self.indicatorView atIndex:0];
    }
}


#pragma mark - - - 添加标题按钮
- (void)setupTitleButtons {
    //All 《文字》 width
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempWidth = [self GG_widthWithString:obj font:self.configure.titleFont];
        self.allBtnTextWidth += tempWidth;
    }];

    //All《文字》+《按钮间距》width
    self.allBtnWidth = self.configure.spacingBetweenButtons * (self.titleArr.count + 1) + self.allBtnTextWidth;
    self.allBtnWidth = ceilf(self.allBtnWidth);

    NSInteger titleCount = self.titleArr.count;
    if (self.allBtnWidth <= self.bounds.size.width) { // SGPageTitleView 静止样式
        CGFloat btnY = 0;
        CGFloat btnW = self.width / self.titleArr.count;
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == GGIndicatorStyleDefault) {
            btnH = self.height - self.configure.indicatorHeight;
        } else {
            btnH = self.height;
        }
        CGFloat VSeparatorW = 1;
        CGFloat VSeparatorH = self.height - self.configure.verticalSeparatorReduceHeight;
        if (VSeparatorH <= 0) {
            VSeparatorH = self.height;
        }
        CGFloat VSeparatorY = 0.5 * (self.height - VSeparatorH);
        for (NSInteger index = 0; index < titleCount; index++) {
            // 1、添加按钮
            UIButton *btn = [[UIButton alloc] init];
            CGFloat btnX = btnW * index;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.tag = index;
            btn.titleLabel.font = self.configure.titleFont;
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleColor forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.selectedTitleColor forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(gg_btn_cilck:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnArr addObject:btn];
            [self.scrollView addSubview:btn];

            //获取开始颜色和结束颜色
            self.startRGB = [self.configure.titleColor getNomalRGB];
            self.endRGB = [self.configure.selectedTitleColor getNomalRGB];

            // 2、添加按钮之间的分割线
            if (self.configure.showVerticalSeparator == YES) {
                UIView *VSeparator = [[UIView alloc] init];
                if (index != 0) {
                    CGFloat VSeparatorX = btnW * index - 0.5;
                    VSeparator.frame = CGRectMake(VSeparatorX, VSeparatorY, VSeparatorW, VSeparatorH);
                    VSeparator.backgroundColor = self.configure.verticalSeparatorColor;
                    [self.scrollView addSubview:VSeparator];
                }
            }
        }
        self.scrollView.contentSize = CGSizeMake(self.width, self.height);

    } else { // SGPageTitleView 滚动样式
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == GGIndicatorStyleDefault) {
            btnH = self.height - self.configure.indicatorHeight;
        } else {
            btnH = self.height;
        }
        CGFloat VSeparatorW = 1;
        CGFloat VSeparatorH = self.height - self.configure.verticalSeparatorReduceHeight;
        if (VSeparatorH <= 0) {
            VSeparatorH = self.height;
        }
        CGFloat VSeparatorY = 0.5 * (self.height - VSeparatorH);
        for (NSInteger index = 0; index < titleCount; index++) {
            // 1、添加按钮
            UIButton *btn = [[UIButton alloc] init];
            CGFloat btnW = [self GG_widthWithString:self.titleArr[index] font:self.configure.titleFont] + self.configure.spacingBetweenButtons;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btnX = btnX + btnW;
            btn.tag = index;
            btn.titleLabel.font = self.configure.titleFont;
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleColor forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.selectedTitleColor forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(gg_btn_cilck:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnArr addObject:btn];
            [self.scrollView addSubview:btn];

            //获取开始颜色和结束颜色
            self.startRGB = [self.configure.titleColor getNomalRGB];
            self.endRGB = [self.configure.selectedTitleColor getNomalRGB];

            // 2、添加按钮之间的分割线
            if (self.configure.showVerticalSeparator == YES) {
                UIView *VSeparator = [[UIView alloc] init];
                if (index < titleCount - 1) {
                    CGFloat VSeparatorX = btnX - 0.5;
                    VSeparator.frame = CGRectMake(VSeparatorX, VSeparatorY, VSeparatorW, VSeparatorH);
                    VSeparator.backgroundColor = self.configure.verticalSeparatorColor;
                    [self.scrollView addSubview:VSeparator];
                }
            }
        }
        CGFloat scrollViewWidth = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, self.height);
    }
}

#pragma mark - - - 标题按钮的点击事件
- (void)gg_btn_cilck:(UIButton *)button {
    // 1、改变按钮的选择状态
    [self P_changeSelectedButton:button];
    // 2、滚动标题选中按钮居中
    if (self.allBtnWidth > self.width) {
        [self P_selectedBtnCenter:button];
    }
    // 3、改变指示器的位置以及指示器宽度样式
    [self P_changeIndicatorViewLocationWithButton:button];
    // 4、pageTitleViewDelegate
    if ([self.delegatePageTitleView respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
        [self.delegatePageTitleView pageTitleView:self selectedIndex:button.tag];
    }
    // 5、标记按钮下标
    self.signBtnIndex = button.tag;
}

#pragma mark - - - 改变按钮的选择状态
- (void)P_changeSelectedButton:(UIButton *)button {
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    } else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;
    } else if (self.tempBtn != button && self.tempBtn != nil){
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    }
    
    if (self.configure.titleSelectedFont == self.configure.titleFont) {
        // 标题文字缩放属性(开启 titleSelectedFont 属性将不起作用)
        if (self.configure.titleTextZoom == YES) {
            [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.transform = CGAffineTransformMakeScale(1, 1);
            }];
            button.transform = CGAffineTransformMakeScale(1 + self.configure.titleTextScaling, 1 + self.configure.titleTextScaling);
        }
        
        // 此处作用：避免滚动内容视图时 手指不离开屏幕的前提下点击按钮后 再次滚动内容视图时按钮文字颜色由于文字渐变效果导致未选中按钮文字的不标准化处理
        if (self.configure.titleGradientEffect == YES) {
            [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.titleLabel.textColor = self.configure.titleColor;
            }];
            button.titleLabel.textColor = self.configure.selectedTitleColor;
        }
    } else {
        // 此处作用：避免滚动内容视图时 手指不离开屏幕的前提下点击按钮后 再次滚动内容视图时按钮文字颜色由于文字渐变效果导致未选中按钮文字的不标准化处理
        if (self.configure.titleGradientEffect == YES) {
            [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.titleLabel.textColor = self.configure.titleColor;
                btn.titleLabel.font = self.configure.titleFont;
            }];
            button.titleLabel.textColor = self.configure.selectedTitleColor;
            button.titleLabel.font = self.configure.titleSelectedFont;
        } else {
            [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = obj;
                btn.titleLabel.font = self.configure.titleFont;
            }];
            button.titleLabel.font = self.configure.titleSelectedFont;
        }
    }
}

#pragma mark - - - 滚动标题选中按钮居中
- (void)P_selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.width * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.width;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - - - 改变指示器的位置以及指示器宽度样式
- (void)P_changeIndicatorViewLocationWithButton:(UIButton *)button {
    [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
        if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
            self.indicatorView.width = self.configure.indicatorFixedWidth;
        } else if (self.configure.indicatorStyle == GGIndicatorStyleDynamic) {
            self.indicatorView.width = self.configure.indicatorDynamicWidth;
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:button.currentTitle font:self.configure.titleFont];
            if (tempIndicatorWidth > button.width) {
                tempIndicatorWidth = button.width;
            }
            self.indicatorView.width = tempIndicatorWidth;
        }
        self.indicatorView.centerX = button.centerX;
    }];
}

#pragma mark - - - 给外界提供的方法
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    // 1、取出 originalBtn／targetBtn
    UIButton *originalBtn = self.btnArr[originalIndex];
    UIButton *targetBtn = self.btnArr[targetIndex];
    self.signBtnIndex = targetBtn.tag;
    // 2、 滚动标题选中居中
    [self P_selectedBtnCenter:targetBtn];
    // 3、处理指示器的逻辑
    if (self.allBtnWidth <= self.bounds.size.width) { /// SGPageTitleView 不可滚动
        if (self.configure.indicatorScrollStyle == GGIndicatorScrollStyleDefault) {
            [self P_smallIndicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self P_smallIndicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }
        
    } else { /// SGPageTitleView 可滚动
        if (self.configure.indicatorScrollStyle == GGIndicatorScrollStyleDefault) {
            [self P_indicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self P_indicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }
    }
    // 4、颜色的渐变(复杂)
    if (self.configure.titleGradientEffect == YES) {
        [self P_isTitleGradientEffectWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
    }
    
    // 5 、标题文字缩放属性(开启文字选中字号属性将不起作用)
    if (self.configure.titleSelectedFont == [UIFont systemFontOfSize:15]) {
        if (self.configure.titleTextZoom == YES) {
            // 左边缩放
            originalBtn.transform = CGAffineTransformMakeScale((1 - progress) * self.configure.titleTextScaling + 1, (1 - progress) * self.configure.titleTextScaling + 1);
            // 右边缩放
            targetBtn.transform = CGAffineTransformMakeScale(progress * self.configure.titleTextScaling + 1, progress * self.configure.titleTextScaling + 1);
        }
    }
}

/**
 *  根据标题下标重置标题文字
 *
 *  @param title    标题名
 *  @param index    标题所对应的下标
 */
- (void)resetTitle:(NSString *)title forIndex:(NSInteger)index {
    UIButton *button = (UIButton *)self.btnArr[index];
    [button setTitle:title forState:UIControlStateNormal];
    if (self.signBtnIndex == index) {
        if (self.configure.indicatorStyle == GGIndicatorStyleDefault || self.configure.indicatorStyle == GGIndicatorStyleCover) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:button.currentTitle font:self.configure.titleFont];
            if (tempIndicatorWidth > button.width) {
                tempIndicatorWidth = button.width;
            }
            self.indicatorView.width = tempIndicatorWidth;
            self.indicatorView.centerX = button.centerX;
        }
    }
}

/**
 *  根据标题下标设置标题的 attributedTitle 属性
 *
 *  @param attributedTitle      attributedTitle 属性
 *  @param selectedAttributedTitle      选中状态下 attributedTitle 属性
 *  @param index     标题所对应的下标
 */
- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle selectedAttributedTitle:(NSMutableAttributedString *)selectedAttributedTitle forIndex:(NSInteger)index {
    UIButton *button = (UIButton *)self.btnArr[index];
    [button setAttributedTitle:attributedTitle forState:(UIControlStateNormal)];
    [button setAttributedTitle:selectedAttributedTitle forState:(UIControlStateSelected)];
}

/**
 *  设置标题图片及位置样式
 *
 *  @param images       默认图片数组
 *  @param selectedImages       选中时图片数组
 *  @param imagePositionType       图片位置样式
 *  @param spacing      图片与标题文字之间的间距
 */

- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectedImages imagePositionType:(GGImagePositionType)imagePositionType spacing:(CGFloat)spacing{
    NSInteger imagesCount = images.count;
    NSInteger selectedImagesCount = selectedImages.count;
    NSInteger titlesCount = self.titleArr.count;
    if (imagesCount < selectedImagesCount) {
        NSLog(@"温馨提示：GGPageTitleView -> [setImages:selectedImages:imagePositionType:spacing] 方法中 images 必须大于或者等于selectedImages，否则 imagePositionTypeDefault 以外的其他样式图片及文字布局将会出现问题");
    }
    
    if (imagesCount < titlesCount) {
        [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            if (idx >= imagesCount - 1) {
                *stop = YES;
            }
            [self P_btn:btn imageName:images[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateNormal)];
        }];
    } else {
        [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            [self P_btn:btn imageName:images[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateNormal)];
        }];
    }
    
    if (selectedImagesCount < titlesCount) {
        [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            if (idx >= selectedImagesCount - 1) {
                *stop = YES;
            }
            [self P_btn:btn imageName:selectedImages[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateSelected)];
        }];
    } else {
        [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            [self P_btn:btn imageName:selectedImages[idx] imagePositionType:imagePositionType spacing:spacing btnControlState:(UIControlStateSelected)];
        }];
    }
}

/// imagePositionType 样式设置方法抽取
- (void)P_btn:(UIButton *)btn imageName:(NSString *)imageName imagePositionType:(GGImagePositionType)imagePositionType spacing:(CGFloat)spacing btnControlState:(UIControlState)btnControlState {
    if (imagePositionType == GGImagePositionTypeDefault) {
        [btn GG_imagePositionStyle:GGImagePositionStyleDefault spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
    } else if (imagePositionType == GGImagePositionTypeRight) {
        [btn GG_imagePositionStyle:GGImagePositionStyleRight spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
    } else if (imagePositionType == GGImagePositionTypeTop) {
        [btn GG_imagePositionStyle:GGImagePositionStyleTop spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
    } else if (imagePositionType == GGImagePositionTypeBottom) {
        [btn GG_imagePositionStyle:GGImagePositionStyleBottom spacing:spacing imagePositionBlock:^(UIButton *button) {
            [btn setImage:[UIImage imageNamed:imageName] forState:btnControlState];
        }];
    }
}

#pragma mark - - - SGPageTitleView 静止样式下指示器默认滚动样式（SGIndicatorScrollStyleDefault）
- (void)P_smallIndicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 1、改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self P_changeSelectedButton:targetBtn];
    }
    
    if (self.configure.indicatorStyle == GGIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        // 按钮之间的距离
        CGFloat distance = self.width / self.titleArr.count;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            if (progress <= 0.5) {
                self.indicatorView.width = self.configure.indicatorDynamicWidth + 2 * progress * distance;
            } else {
                CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (distance - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                self.indicatorView.x = targetBtnIndicatorX + 2 * (progress - 1) * distance;
                self.indicatorView.width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * distance;
            }
        } else {
            if (progress <= 0.5) {
                CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (distance - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                self.indicatorView.x = originalBtnIndicatorX - 2 * progress * distance;
                self.indicatorView.width = self.configure.indicatorDynamicWidth + 2 * progress * distance;
            } else {
                CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (distance - self.configure.indicatorDynamicWidth);
                self.indicatorView.x = targetBtnIndicatorX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                self.indicatorView.width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * distance;
            }
        }
        
    } else if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.width / self.titleArr.count - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.width / self.titleArr.count - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        self.indicatorView.x = originalBtnIndicatorX + progress * totalOffsetX;
        
    } else {
        /// 1、计算 indicator 偏移量
        // targetBtn 文字宽度
        CGFloat targetBtnTextWidth = [self GG_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - targetBtnTextWidth - 0.5 * (self.width / self.titleArr.count - targetBtnTextWidth + self.configure.indicatorAdditionalWidth);
        // originalBtn 文字宽度
        CGFloat originalBtnTextWidth = [self GG_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - originalBtnTextWidth - 0.5 * (self.width / self.titleArr.count - originalBtnTextWidth + self.configure.indicatorAdditionalWidth);
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        
        /// 2、计算文字之间差值
        // 按钮宽度的距离
        CGFloat btnWidth = self.width / self.titleArr.count;
        // targetBtn 文字右边的 x 值
        CGFloat targetBtnRightTextX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (btnWidth - targetBtnTextWidth);
        // originalBtn 文字右边的 x 值
        CGFloat originalBtnRightTextX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (btnWidth - originalBtnTextWidth);
        CGFloat totalRightTextDistance = targetBtnRightTextX - originalBtnRightTextX;
        
        // 计算 indicatorView 滚动时 x 的偏移量
        CGFloat offsetX = totalOffsetX * progress;
        // 计算 indicatorView 滚动时文字宽度的偏移量
        CGFloat distance = progress * (totalRightTextDistance - totalOffsetX);
        
        /// 3、计算 indicatorView 新的 frame
        self.indicatorView.x = originalBtnIndicatorX + offsetX;
        
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + originalBtnTextWidth + distance;
        if (tempIndicatorWidth >= targetBtn.width) {
            CGFloat moveTotalX = targetBtn.origin.x - originalBtn.origin.x;
            CGFloat moveX = moveTotalX * progress;
            self.indicatorView.centerX = originalBtn.centerX + moveX;
        } else {
            self.indicatorView.width = tempIndicatorWidth;
        }
    }
}

#pragma mark - - - SGPageTitleView 滚动样式下指示器默认滚动样式（SGIndicatorScrollStyleDefault）
- (void)P_indicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /// 改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self P_changeSelectedButton:targetBtn];
    }
    
    if (self.configure.indicatorStyle == GGIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            // targetBtn 与 originalBtn 中心点之间的距离
            CGFloat btnCenterXDistance = targetBtn.centerX - originalBtn.centerX;
            if (progress <= 0.5) {
                self.indicatorView.width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.width - self.configure.indicatorDynamicWidth);
                self.indicatorView.x = targetBtnX + 2 * (progress - 1) * btnCenterXDistance;
                self.indicatorView.width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            }
        } else {
            // originalBtn 与 targetBtn 中心点之间的距离
            CGFloat btnCenterXDistance = originalBtn.centerX - targetBtn.centerX;
            if (progress <= 0.5) {
                CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (originalBtn.width - self.configure.indicatorDynamicWidth);
                self.indicatorView.x = originalBtnX - 2 * progress * btnCenterXDistance;
                self.indicatorView.width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.width - self.configure.indicatorDynamicWidth);
                self.indicatorView.x = targetBtnX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                self.indicatorView.width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            }
        }
        
    } else if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (targetBtn.width - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorFixedWidth - 0.5 * (originalBtn.width - self.configure.indicatorFixedWidth);
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        CGFloat offsetX = totalOffsetX * progress;
        self.indicatorView.x = originalBtnIndicatorX + offsetX;
        
    } else {
        // 1、计算 targetBtn／originalBtn 之间的 x 差值
        CGFloat totalOffsetX = targetBtn.origin.x - originalBtn.origin.x;
        // 2、计算 targetBtn／originalBtn 之间的差值
        CGFloat totalDistance = CGRectGetMaxX(targetBtn.frame) - CGRectGetMaxX(originalBtn.frame);
        /// 计算 indicatorView 滚动时 x 的偏移量
        CGFloat offsetX = 0.0;
        /// 计算 indicatorView 滚动时宽度的偏移量
        CGFloat distance = 0.0;
        
        CGFloat targetBtnTextWidth = [self GG_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + targetBtnTextWidth;
        if (tempIndicatorWidth >= targetBtn.width) {
            offsetX = totalOffsetX * progress;
            distance = progress * (totalDistance - totalOffsetX);
            self.indicatorView.x = originalBtn.origin.x + offsetX;
            self.indicatorView.width = originalBtn.width + distance;
        } else {
            offsetX = totalOffsetX * progress + 0.5 * self.configure.spacingBetweenButtons - 0.5 * self.configure.indicatorAdditionalWidth;
            distance = progress * (totalDistance - totalOffsetX) - self.configure.spacingBetweenButtons;
            /// 计算 indicatorView 新的 frame
            self.indicatorView.x = originalBtn.origin.x + offsetX;
            self.indicatorView.width = originalBtn.width + distance + self.configure.indicatorAdditionalWidth;
        }
    }
}

#pragma mark - - - SGPageTitleView 静止样式下指示器 SGIndicatorScrollStyleHalf 和 SGIndicatorScrollStyleEnd 滚动样式
- (void)P_smallIndicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    if (self.configure.indicatorScrollStyle == GGIndicatorScrollStyleHalf) {
        if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.centerX = targetBtn.centerX;
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.centerX = originalBtn.centerX;
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        /// 指示器默认样式以及遮盖样式处理
        if (progress >= 0.5) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.width) {
                    self.indicatorView.width = targetBtn.width;
                } else {
                    self.indicatorView.width = tempIndicatorWidth;
                }
                self.indicatorView.centerX = targetBtn.centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.width) {
                    self.indicatorView.width = originalBtn.width;
                } else {
                    self.indicatorView.width = tempIndicatorWidth;
                }
                self.indicatorView.centerX = originalBtn.centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    /// 滚动内容结束指示器处理 ____ 指示器默认样式以及遮盖样式处理
    if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
        if (progress == 1.0) {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.centerX = targetBtn.centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.centerX = originalBtn.centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    if (progress == 1.0) {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.width) {
                self.indicatorView.width = targetBtn.width;
            } else {
                self.indicatorView.width = tempIndicatorWidth;
            }
            self.indicatorView.centerX = targetBtn.centerX;
            [self P_changeSelectedButton:targetBtn];
        }];
    } else {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.width) {
                self.indicatorView.width = originalBtn.width;
            } else {
                self.indicatorView.width = tempIndicatorWidth;
            }
            self.indicatorView.centerX = originalBtn.centerX;
            [self P_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - SGPageTitleView 滚动样式下指示器 SGIndicatorScrollStyleHalf 和 SGIndicatorScrollStyleEnd 滚动样式
- (void)P_indicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    if (self.configure.indicatorScrollStyle == GGIndicatorScrollStyleHalf) {
        if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.centerX = targetBtn.centerX;
                    [self P_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.centerX = originalBtn.centerX;
                    [self P_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        /// 指示器默认样式以及遮盖样式处理
        if (progress >= 0.5) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.width) {
                    self.indicatorView.width = targetBtn.width;
                } else {
                    self.indicatorView.width = tempIndicatorWidth;
                }
                self.indicatorView.centerX = targetBtn.centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= originalBtn.width) {
                    self.indicatorView.width = originalBtn.width;
                } else {
                    self.indicatorView.width = tempIndicatorWidth;
                }
                self.indicatorView.centerX = originalBtn.centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    /// 滚动内容结束指示器处理 ____ 指示器默认样式以及遮盖样式处理
    if (self.configure.indicatorStyle == GGIndicatorStyleFixed) {
        if (progress == 1.0) {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.centerX = targetBtn.centerX;
                [self P_changeSelectedButton:targetBtn];
            }];
        } else {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.centerX = originalBtn.centerX;
                [self P_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    if (progress == 1.0) {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.width) {
                self.indicatorView.width = targetBtn.width;
            } else {
                self.indicatorView.width = tempIndicatorWidth;
            }
            self.indicatorView.centerX = targetBtn.centerX;
            [self P_changeSelectedButton:targetBtn];
        }];
        
    } else {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self GG_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= originalBtn.width) {
                self.indicatorView.width = originalBtn.width;
            } else {
                self.indicatorView.width = tempIndicatorWidth;
            }
            self.indicatorView.centerX = originalBtn.centerX;
            [self P_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - 颜色渐变方法抽取
- (void)P_isTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 获取 targetProgress
    CGFloat targetProgress = progress;
    // 获取 originalProgress
    CGFloat originalProgress = 1 - targetProgress;

    CGFloat r = self.endRGB[0].floatValue - self.startRGB[0].floatValue;
    CGFloat g = self.endRGB[1].floatValue - self.startRGB[1].floatValue;
    CGFloat b = self.endRGB[2].floatValue - self.startRGB[2].floatValue;

    // 设置文字颜色渐变
    originalBtn.titleLabel.textColor = [UIColor colorWithRed:self.startRGB[0].floatValue +  r * originalProgress  green:self.startRGB[1].floatValue +  g * originalProgress  blue:self.startRGB[2].floatValue +  b * originalProgress alpha:1];
    targetBtn.titleLabel.textColor = [UIColor colorWithRed:self.startRGB[0].floatValue + r * targetProgress green:self.startRGB[1].floatValue + g * targetProgress blue:self.startRGB[2].floatValue + b * targetProgress alpha:1];
}

#pragma mark - - - 计算字符串宽度、高度
- (CGFloat)GG_widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

- (CGFloat)GG_heightWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}
@end


