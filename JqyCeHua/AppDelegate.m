//
//  AppDelegate.m
//  JqyCeHua
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import "AppDelegate.h"

#import "JqyCeHuaController.h"

#import "ViewController.h"

#import "HomeController.h"

#import "CeYeView.h"

@interface AppDelegate ()<JqyCeHuaCongtrollerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
#warning 如果侧滑视图是主界面建议使用单利初始化
/* 也可一般初始化
 * JqyCeHuaController *Jqy_ceHuaVc = [JqyCeHuaController new];
 */
    Jqy_ceHuaVc.delegate = self;
    
    Jqy_ceHuaVc.isDianJiHuiShou = YES;
    
    //从侧滑页跳转时即将消失回调
    Jqy_ceHuaVc.WillDisappearBlock = ^{
      
        [Jqy_ceHuaVc ziDongHuiShouAnimated:YES]; //自动回收
        
    };
    
    HomeController *zhuVc = [[HomeController alloc]init];
    zhuVc.openBlock = ^{
      
      [Jqy_ceHuaVc ziDongKaiQiAnimated:YES]; //自动开启
        
    };
    
#warning 注意从主页跳转消失后要关闭可滑动  显示后打开  (从滑动页跳转可不用设置)
    zhuVc.apperBlock = ^{
        
        Jqy_ceHuaVc.superScrollView.scrollEnabled = YES;
    };
    
    zhuVc.disappearBlock = ^{
      
        Jqy_ceHuaVc.superScrollView.scrollEnabled = NO;
        
    };
    
    
    CeYeView *ceView = [[CeYeView alloc]init];
    ceView.dianjiBlock = ^{
        
        [Jqy_ceHuaVc ziDongHuiShouAnimated:YES];
       
    };
    
#warning 设置侧滑页的侧边页
    Jqy_ceHuaVc.ceView = ceView;
    
    UINavigationController *zhuNaVc = [[UINavigationController alloc]initWithRootViewController:zhuVc];;
#warning 设置侧滑页的主页
    Jqy_ceHuaVc.zhuController = zhuNaVc;

// 覆盖区域 有默认
//    Jqy_ceHuaVc.fuGaiWidth = 327.4432;
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *ceHuaNaVc = [[UINavigationController alloc]initWithRootViewController:Jqy_ceHuaVc];
    self.window.rootViewController = ceHuaNaVc;
#warning 如果侧滑页有导航栏设置此属性为YES 没有就不要设置或设置成NO 
    Jqy_ceHuaVc.isHasNavigationBar = YES;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

#pragma mark >>>>>>>>>>>>>>.. 代理

/*
 * 将要展开
 */
- (void)willOpen{
    
    NSLog(@"将要展开");
}

///*
// * 已经展开
// */
//- (void)didOpen{
//    
//    NSLog(@"已经展开");
//}
//
///*
// * 将要关闭
// */
//- (void)willClose{
//    
//    NSLog(@"将要关闭");
//}

/*
 * 已经关闭
 */
- (void)didClose {
    
     NSLog(@"已经关闭");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
