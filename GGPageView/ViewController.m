//
//  ViewController.m
//  GGPageView
//
//  Created by Mac on 2018/6/4.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"

#import "TestDefaultVC.h"

/// 底部宏，吃一见长一智吧，别写数字了
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX ([UIScreen mainScreen].bounds.size.width>=375.0f && [UIScreen mainScreen].bounds.size.height>=812.0f && IS_IPHONE)

// 导航栏默认高度
#define  E_StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

@interface ViewController ()
{
    NSArray *_titleArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"固定样式",@"可滚动",@"图标样式"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kfkahkldsfhlhasfgla"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kfkahkldsfhlhasfgla" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[TestDefaultVC alloc] init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
