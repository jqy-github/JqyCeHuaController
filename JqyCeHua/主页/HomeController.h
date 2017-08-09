//
//  HomeController.h
//  Ios侧滑
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UITabBarController

@property (nonatomic,copy)void(^openBlock)();

@property (nonatomic,copy)void(^apperBlock)();

@property (nonatomic,copy)void(^disappearBlock)();


@end
