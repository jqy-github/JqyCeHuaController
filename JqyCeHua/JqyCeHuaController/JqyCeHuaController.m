//
//  JqyCeHuaController.m
//  JqyCeHua
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import "JqyCeHuaController.h"


#define K_Width [UIScreen mainScreen].bounds.size.width

#define K_Height [UIScreen mainScreen].bounds.size.height


@implementation SuperScrollView

/*
 * 重写初始化
 */
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delaysContentTouches = NO;
       
    }
    
    return self;
}

/*
 * 防止手势冲突
 */
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view {
    
    
    UITouch *beginTouch = [touches anyObject];
    
    CGPoint beginPoint = [beginTouch locationInView:self];

    
    if ((beginPoint.x < self.keHuaDongX) && (beginPoint.x > self.keHuaDongX - 25)) {
        
        if (self.isJiluHuaDongQu) {
            
            Jqy_ceHuaVc.isDianJiCeHuaQu = YES;
        }
   
    
        return NO;
        
        
    }else {
   
        if (self.isJiluHuaDongQu) {
            
           Jqy_ceHuaVc.isDianJiCeHuaQu = NO;
        }
        
        return YES;
    }
}


@end



@interface JqyCeHuaController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *coverView; //覆盖View
@property (nonatomic,assign)CGFloat zhuangTaiY; //状态高
@property (nonatomic,assign)BOOL isDanLi; //是否单利初始化
@property (nonatomic,assign)BOOL isBeginDragging; //判断是否拖拽 防止未拖拽情况下执行代理

@end

@implementation JqyCeHuaController

/*
 * 单利初始化
 */

+ (instancetype)ceHuaSingle {
    
    static JqyCeHuaController *ceHuaVc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ceHuaVc = [[JqyCeHuaController alloc]init];
        ceHuaVc.isDanLi = YES;
        
    });
    
    return ceHuaVc;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setViews]; //布局
    
    // Do any additional setup after loading the view.
}

/*
 * 布局
 */
- (void)setViews {
    

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置默认数值
    if (self.fuGaiWidth <= 0) {
        
        self.fuGaiWidth = K_Width*0.75;
    }
    
    //隐藏导航栏
    if (self.isHasNavigationBar) {
        
        _zhuangTaiY = 64;
    }
  
    //可滑动的父视图
    self.superScrollView = [[SuperScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.superScrollView.contentSize = CGSizeMake(K_Width + self.fuGaiWidth, K_Height - _zhuangTaiY);
    self.superScrollView.contentOffset = CGPointMake(self.fuGaiWidth, 0);
    self.superScrollView.showsHorizontalScrollIndicator = NO;
    self.superScrollView.keHuaDongX = self.fuGaiWidth + 25;
    if (self.isDanLi) {
        
        self.superScrollView.isJiluHuaDongQu = YES;
    }
    [self.view addSubview:self.superScrollView];
    
    //侧边栏
    if (self.ceView) {
        
      self.ceView.frame = CGRectMake(- (K_Width - self.fuGaiWidth), - _zhuangTaiY, K_Width, K_Height);
      [self.superScrollView addSubview:self.ceView];
    }
   
    
    //主视图
    if (self.zhuController) {
        
        self.zhuController.view.frame = CGRectMake(self.fuGaiWidth, - _zhuangTaiY, K_Width, K_Height);
        [self.superScrollView addSubview:self.zhuController.view];
       
    }
    
    
    //滑出后覆盖的View
    self.coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.coverView.alpha = 0;
    [self.zhuController.view addSubview:self.coverView];
    
    if (_isDianJiHuiShou) {
        
        UITapGestureRecognizer *huiSouTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huiShouGesture:)];
        
        [self.coverView addGestureRecognizer:huiSouTap];
    }
 
    self.superScrollView.delegate = self;
}


/*
 * 点击覆盖页
 */
- (void)huiShouGesture:(UITapGestureRecognizer *)gesture {
    
    [self ziDongHuiShouAnimated:YES];
    
}

/*
 * 实现滑动ing代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.ceView.frame = CGRectMake( - (scrollView.contentOffset.x / (self.fuGaiWidth/(K_Width-self.fuGaiWidth))), - _zhuangTaiY, K_Width, K_Height);
    

    self.coverView.alpha = 1 - (scrollView.contentOffset.x / (self.fuGaiWidth/1));
    
}

/*
 * 开始拖拽
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.isBeginDragging = YES;

    NSInteger contentX = [[NSString stringWithFormat:@"%.f",scrollView.contentOffset.x] integerValue];
   
      //将要开启
    if (self.delegate && [self.delegate respondsToSelector:@selector(willOpen)]) {
            
        if (contentX == self.fuGaiWidth) {
            
             [self.delegate willOpen];
        }
    
    }
    
    //将要关闭
    if (self.delegate && [self.delegate respondsToSelector:@selector(willClose)]) {
            
        if (contentX == 0) {
            
            [self.delegate willClose];
        }
    }
    
}

/*
 * 结束拖拽
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger contentX = [[NSString stringWithFormat:@"%.f",scrollView.contentOffset.x] integerValue];
    
    if (self.isBeginDragging) {
    
            //已经开启
        if (self.delegate && [self.delegate respondsToSelector:@selector(didOpen)]) {
                
             if (contentX == 0) {
                
                [self.delegate didOpen];
            }
        
        }
        
        //已经关闭
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClose)]) {
            
           if (contentX == self.fuGaiWidth) {
            
                [self.delegate didClose];
        
             }
        }

}
    
    self.isBeginDragging = NO;
}


/*
 * 自动开启
 */
- (void)ziDongKaiQiAnimated:(BOOL)animated{
    
    //执行开启代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOpen)]) {
        
        self.isBeginDragging = YES;
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willOpen)]) {
        
        [self.delegate willOpen];
    }
    
    if (animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width, K_Height);
            
            self.superScrollView.contentOffset = CGPointMake(0, - _zhuangTaiY);
            
        }];
        
    }else {
        
        self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width, K_Height);
        
        self.superScrollView.contentOffset = CGPointMake(0, - _zhuangTaiY);
    }
    
}

/*
 * 自动关闭
 */

- (void)ziDongHuiShouAnimated:(BOOL)animated{
    
    //执行关闭代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClose)]) {
        
        self.isBeginDragging = YES;
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willClose)]) {
        
        [self.delegate willClose];
    }
    
    if (animated) {
     
        [UIView animateWithDuration:0.3 animations:^{
            
            self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width + self.fuGaiWidth, K_Height);
            
            self.superScrollView.contentOffset = CGPointMake(self.fuGaiWidth, - _zhuangTaiY);
        }];
        
    }else {
        
        self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width + self.fuGaiWidth, K_Height);
        
        self.superScrollView.contentOffset = CGPointMake(self.fuGaiWidth, - _zhuangTaiY);
    }
   
}


/*
 * 界面跳转时回调
 */
- (void)viewDidAppear:(BOOL)animated {
    
    if (self.isHasNavigationBar) {
        
        self.navigationController.navigationBar.hidden = YES;
    }

    
    if (self.DidAppearBlock) {
        
        self.DidAppearBlock();
    }
    
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {

    if (self.isHasNavigationBar){
        
        self.navigationController.navigationBar.hidden = NO;
    }
    
    if (self.WillDisappearBlock) {
        
        self.WillDisappearBlock();
    }
    
    [super viewWillDisappear:YES];
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
