//
//  JqyCeHuaController.h
//  JqyCeHua
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#define Jqy_ceHuaVc [JqyCeHuaController ceHuaSingle]

#import <UIKit/UIKit.h>

#pragma mark -------- 自定义ScorllView --------

@interface SuperScrollView : UIScrollView
/*
 * 防治与子视图手势冲突设置允许拖动的距离x
 */
@property (nonatomic,assign)CGFloat keHuaDongX;

@property (nonatomic,assign)BOOL isJiluHuaDongQu; //是否记录滑动区

@end

#pragma mark ----------- JqyCeHuaController ---------

#pragma >>>>>>>>>>>>>代理

@protocol JqyCeHuaCongtrollerDelegate <NSObject>

/*
 * 将要展开
 */
- (void)willOpen;

/*
 * 已经展开
 */
- (void)didOpen;

/*
 * 将要关闭
 */
- (void)willClose;

/*
 * 已经关闭
 */
- (void)didClose;



@end

typedef NS_ENUM(NSInteger, UICeHuaStyle) {
   
    UIFenLiCeHuaStyle = 0,
    UIHeBingCeHuaStyle
    
};

@interface JqyCeHuaController : UIViewController

#pragma >>>>>>>>>>>>>>属性

/*
 * 侧滑样式
 */
@property (nonatomic,assign)UICeHuaStyle ceHuaStyle;


/*
 * 代理
 */
@property (nonatomic,weak)id <JqyCeHuaCongtrollerDelegate>delegate;

/*
 * 自定义ScorllView
 */
@property (nonatomic,strong)SuperScrollView *superScrollView;

/*
 * 侧边视图
 */
@property (nonatomic,strong)UIView *ceView;

/*
 *主页控制图
 */
@property (nonatomic,strong)UIViewController *zhuController;

/*
 * 设置侧栏宽度
 */
@property (nonatomic,assign)NSInteger ceLanWidth;

/*
 * 是否有导航栏
 */
@property (nonatomic,assign)BOOL isHasNavigationBar;

/*
 * 点击主页是否自动回收
 */
@property (nonatomic,assign)BOOL isDianJiHuiShou;

/*
 * 侧滑页将要出现回调
 */
@property (nonatomic,copy)void(^DidAppearBlock)();

/*
 * 侧滑页将要消失回调
 */
@property (nonatomic,copy)void(^WillDisappearBlock)();

#warning 是否点击到侧滑区域 主要用在 解决手势冲突时产生的Bug 见 ViewController3
@property (nonatomic,assign)BOOL isDianJiCeHuaQu;


#pragma >>>>>>>>>>>>>>>>方法
/*
 * 自动开启
 */
- (void)ziDongKaiQiAnimated:(BOOL)animated;

/*
 * 自动回收
 */
- (void)ziDongHuiShouAnimated:(BOOL)animated;

/*
 * 单利初始化
 */
+ (instancetype)ceHuaSingle;

@end
