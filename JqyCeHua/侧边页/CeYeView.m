//
//  CeYeView.m
//  JqyCeHua
//
//  Created by 开发者 on 2017/8/7.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import "CeYeView.h"

#import "ViewController.h"

@interface CeYeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *listArray;

@end

@implementation CeYeView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setViews];
    }
    
    return self;
}

- (void)setViews {
    
    UIImageView *backImv = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backImv.image = [[UIImage imageNamed:@"653d6336d8a45465cab49a07670b281a.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addSubview:backImv];
    
    
    UITableView *list = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, 200, [UIScreen mainScreen].bounds.size.height - 200) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundColor = [UIColor clearColor];
    [self addSubview:list];
    
    
}

- (NSArray *)listArray {
    
    if (_listArray == nil) {
        
        _listArray = @[@"我的太阳",@"我的玫瑰花",@"我的猫",@"我的沙发",@"我的床",@"我的数据线",@"我的鼠标",@"我的电脑"];
    }
    
    return _listArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.listArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        self.dianjiBlock();
        
    }else {
        
        ViewController *vc = [ViewController new];
        vc.title = self.listArray[indexPath.row];
        [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
 
   
    
}

- (UIViewController *)getCurrentVC{
    

    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    
    //  如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];  // <span style="font-family: Arial, Helvetica, sans-serif;">//  这方法下面有详解    </span>
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    
    return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
