//
//  TestDefaultVC.m
//  GGPageView
//
//  Created by Mac on 2018/6/7.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "TestDefaultVC.h"
#import "GGPageContentView.h"
#import "GGPageTitleView.h"
#import "GGPageTitleViewConfigure.h"
#import "UIView+GGPageView.h"
#import "UIColor+GGPageView.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX ([UIScreen mainScreen].bounds.size.width>=375.0f && [UIScreen mainScreen].bounds.size.height>=812.0f && IS_IPHONE)

// 导航栏默认高度
#define  E_StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

@interface TestDefaultVC ()<GGPageTitleViewDelegate,GGPageContentViewDelegate>
@property (nonatomic, strong)GGPageTitleView *titleView;
@property (nonatomic, strong)GGPageContentView *contentView;

@end

@implementation TestDefaultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *titles = @[@"分类",@"推荐",@"全部",@"刺激战场",@"绝地求生",@"王者荣耀",@"LOL",@"主机游戏",@"QQ飞车",@"全军出击",@"DATA2",@"炉石传说",@"DNF",@"CF手游",@"网游晋级",@"单机热游",@"手游休闲",@"娱乐天地",@"颜值",@"科技教育",@"正能量",@"语音直播",@"体育频道"];
    
    GGPageTitleViewConfigure *configure = [GGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorColor = [UIColor blackColor];
    
    _titleView = [GGPageTitleView pageTitleViewWithFrame:CGRectMake(0, E_StatusBarAndNavigationBarHeight, self.view.width, 44) delegate:self titleNames:titles configure:configure];
    
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVcs = [NSMutableArray array];

    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor randomColor];
        [childVcs addObject:vc];
    }

    _contentView = [GGPageContentView pageContentCollectionViewWithFrame:CGRectMake(0, E_StatusBarAndNavigationBarHeight+44, self.view.width, self.view.height - E_StatusBarAndNavigationBarHeight-44) parentVC:self childVCs:childVcs];
    _contentView.delegatePageContentView = self;
    [self.view addSubview:_contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pageContentCollectionView:(GGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
    NSLog(@"%ld---%ld",originalIndex,targetIndex);
    [self.titleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageTitleView:(GGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self.contentView setPageContentCollrctionViewCurrentIndex:selectedIndex];
}

@end
