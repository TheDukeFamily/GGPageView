//
//  GGPageContentView.m
//  GGPageView
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGPageContentView.h"
#import "UIView+GGPageView.m"

@interface GGPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *childControllers;
//刚开始的偏移量
@property (nonatomic, assign) NSInteger starOffSetX;
// 记录加载的上个自控制器的下标
@property (nonatomic, assign) NSInteger previousVCIndex;
@end

@implementation GGPageContentView

static NSString *const GGPageContentcellID = @"GGPageContentViewCell";

#pragma mark --- lazy load
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.width, self.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.opaque = NO;//不透明
        _collectionView.bounces = YES;//弹簧效果
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;//分页
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:GGPageContentcellID];
    }
    return _collectionView;
}

#pragma mark --- set
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled{
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        _collectionView.scrollEnabled = YES;//允许滚动
    }else{
        _collectionView.scrollEnabled = NO;//不允许滚动
    }
}

- (void)setIsScrollBounces:(BOOL)isScrollBounces{
    _isScrollBounces = isScrollBounces;
    if (isScrollBounces) {
        _collectionView.bounces = YES;
    }else{
        _collectionView.bounces = NO;
    }
}

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs{
    if (self = [super initWithFrame:frame]) {
        if (parentVC == nil) @throw [NSException exceptionWithName:@"GGPagingView" reason:@"初始化方法中所在控制器必须设置" userInfo:nil];
        if (childVCs == nil) @throw [NSException exceptionWithName:@"GGPagingView" reason:@"初始化方法中子控制器必须设置" userInfo:nil];
        
        self.parentViewController = parentVC;
        self.childControllers = childVCs;
        
        _starOffSetX = 0;
        _previousVCIndex = -1;
        
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageContentCollectionViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs{
    return [[self alloc] initWithFrame:frame parentVC:parentVC childVCs:childVCs];
}

- (void)setupSubviews{
    //处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    [self addSubview:self.collectionView];
}

#pragma mark - collection delegate datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPageContentcellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVC = self.childControllers[indexPath.item];
    [cell.contentView addSubview:childVC.view];
    childVC.view.frame = cell.contentView.frame;
    [childVC didMoveToParentViewController:self.parentViewController];
    return cell;
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _starOffSetX = scrollView.contentOffset.x;
}

// 停止拖拽的时候开始执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    //1.记录上个子控制器下标
    _previousVCIndex = offsetX/scrollView.width;
    
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

// 减速停止的时候开始执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

//正在拖动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat progress = 0;//滑动百分比
    NSInteger originalIndex = 0;//原来的下标
    NSInteger targetIndex = 0;//目标下标值
    
    //左滑还是右滑
    CGFloat curreenOffSetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (curreenOffSetX > _starOffSetX) {//左边滑动
        //floor小数取整 例：3.01~3.99 = 3
        progress = curreenOffSetX/scrollViewW - floor(curreenOffSetX/scrollViewW);
        originalIndex = curreenOffSetX/scrollViewW;
        targetIndex = originalIndex+1;
        
        //越界处理
        if (targetIndex >= self.childControllers.count) {
            progress = 1;
            targetIndex = originalIndex;
        }
        
        //刚好滑了整个屏幕的width（如果完全划过去）
        if (curreenOffSetX - _starOffSetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    }else{//右边滑动
            progress = 1 - ((curreenOffSetX/scrollViewW) - floor(curreenOffSetX/scrollViewW));
            targetIndex = curreenOffSetX/scrollViewW;
            originalIndex  = targetIndex+1;
            if (originalIndex >= self.childControllers.count) {
                originalIndex = self.childControllers.count-1;
            }
    }
    if (curreenOffSetX < _starOffSetX && curreenOffSetX <= 0) {
        return;
    }else{
        if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentCollectionView:progress:originalIndex:targetIndex:)]) {
        [self.delegatePageContentView pageContentCollectionView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
    }
}

#pragma mark - - - 给外界提供的方法，获取 self 选中按钮的下标
- (void)setPageContentCollrctionViewCurrentIndex:(NSInteger)currentIndex{
    //处理偏移量
    CGFloat offsetX = currentIndex * self.collectionView.width;
    if (_previousVCIndex != currentIndex) {
        self.collectionView.contentOffset = CGPointMake(offsetX, 0);
    }
    //记录上个控制器下标
    _previousVCIndex = currentIndex;
    
    if (self.delegatePageContentView && [self.delegatePageContentView respondsToSelector:@selector(pageContentView:offsetX:)]) {
        [self.delegatePageContentView pageContentView:self offsetX:offsetX];
    }
}

@end
