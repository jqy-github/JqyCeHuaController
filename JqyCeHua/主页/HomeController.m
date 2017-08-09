//
//  HomeController.m
//  Ios侧滑
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import "HomeController.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController5.h"
#import "ViewController6.h"
#import "ViewController.h"
@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:67/255.0 green:171/255.0 blue:236/255.0 alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    self.title = @"消息";

    
    ViewController3 *vC1 = [ViewController3 new];
    vC1.title = @"消息";
    vC1.tabBarItem.image = [UIImage imageNamed:@"消息"];
    
    ViewController5 *vC2 = [ViewController5 new];
    vC2.title = @"联系人";
    vC2.tabBarItem.image = [UIImage imageNamed:@"联系人"];

    ViewController6 *vC3 = [ViewController6 new];
    vC3.title = @"动态";
    vC3.tabBarItem.image = [UIImage imageNamed:@"星"];
    
    self.viewControllers = @[vC1,vC2,vC3];

    UIButton *headBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [headBtn setImage:[[UIImage imageNamed:@"903cb95eafbbf9e83264e87bf8c3a451.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [headBtn addTarget:self action:@selector(toVc3:) forControlEvents:UIControlEventTouchUpInside];
    headBtn.layer.cornerRadius = 35/2;
    headBtn.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:headBtn];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"看看" style:UIBarButtonItemStylePlain target:self action:@selector(kanAction:)];

}

- (void)kanAction:(UIBarButtonItem *)btn {
    
    [self.navigationController pushViewController:[ViewController4 new] animated:YES];
    
}

#warning 注意从主页跳转消失后要关闭可滑动  显示后打开  (从滑动页跳转可不用设置)

- (void)viewWillAppear:(BOOL)animated {
    
    self.apperBlock();
    
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.disappearBlock();
    
    [super viewWillDisappear:YES];
}




- (void)toVc3:(UIButton *)btn {
    
    self.openBlock();
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    self.title = item.title;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
