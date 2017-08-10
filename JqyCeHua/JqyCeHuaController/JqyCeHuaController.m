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
@property (nonatomic,assign)NSInteger draggContentX; //记录拖拽时的x
@property (nonatomic,assign)BOOL isDidScroll; //是否滑动过
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
    if (self.ceLanWidth <= 0) {
    
        self.ceLanWidth = K_Width*0.75;
    }
    
    //如果是分离式则不能小于屏幕宽
    if ((self.ceLanWidth < K_Width/2) && self.ceHuaStyle == UIFenLiCeHuaStyle) {
        
        self.ceLanWidth = K_Width/2 + 20;
    }
    
    //隐藏导航栏
    if (self.isHasNavigationBar) {
        
        _zhuangTaiY = 64;
    }
  
    //可滑动的父视图
    self.superScrollView = [[SuperScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.superScrollView.contentSize = CGSizeMake(K_Width + self.ceLanWidth, K_Height - _zhuangTaiY);
    self.superScrollView.contentOffset = CGPointMake(self.ceLanWidth, 0);
    self.superScrollView.showsHorizontalScrollIndicator = NO;
    self.superScrollView.keHuaDongX = self.ceLanWidth + 25;
    self.superScrollView.backgroundColor = [UIColor redColor];
    if (self.isDanLi) {
        
        self.superScrollView.isJiluHuaDongQu = YES;
    }
    [self.view addSubview:self.superScrollView];
    
    //侧边栏
    if (self.ceView) {
        
      self.ceView.frame = CGRectMake(self.ceHuaStyle ? -(K_Width - self.ceLanWidth) : (K_Width - self.ceLanWidth), - _zhuangTaiY, K_Width, K_Height);
      [self.superScrollView addSubview:self.ceView];
    }
   
    
    //主视图
    if (self.zhuController) {
        
        self.zhuController.view.frame = CGRectMake(self.ceLanWidth,  - _zhuangTaiY, K_Width, K_Height);
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

    CGFloat ceViewX = scrollView.contentOffset.x / (self.ceLanWidth/(K_Width-self.ceLanWidth));
    
    self.ceView.frame = CGRectMake(self.ceHuaStyle ? - ceViewX : ceViewX, scrollView.contentOffset.y, K_Width, K_Height);
    
    self.zhuController.view.frame = CGRectMake(self.zhuController.view.frame.origin.x, scrollView.contentOffset.y, self.zhuController.view.frame.size.width, self.zhuController.view.frame.size.height);

    self.coverView.alpha = 1 - (scrollView.contentOffset.x / (self.ceLanWidth/1));
    
  
    if (self.isBeginDragging) {
        
        self.isDidScroll = YES;
        
        //将要开启
        if (self.delegate && [self.delegate respondsToSelector:@selector(willOpen)]) {
            
            if (self.draggContentX == self.ceLanWidth) {
                
                [self.delegate willOpen];
            }
            
        }
        
        //将要关闭
        if (self.delegate && [self.delegate respondsToSelector:@selector(willClose)]) {
            
            if (self.draggContentX == 0) {
                
                [self.delegate willClose];
            }
        }
        
        self.isBeginDragging = NO;
    }
    
}

/*
 * 开始拖拽
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.draggContentX = [[NSString stringWithFormat:@"%.f",scrollView.contentOffset.x] integerValue];
    self.isBeginDragging = YES;
}



/*
 * 结束拖拽
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (self.isDidScroll) {
    
         NSInteger contentX = [[NSString stringWithFormat:@"%.f",scrollView.contentOffset.x] integerValue];
        
            //已经开启
        if (self.delegate && [self.delegate respondsToSelector:@selector(didOpen)]) {
                
             if (contentX == 0) {
                
                [self.delegate didOpen];
            }
        
        }
        
        //已经关闭
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClose)]) {
            
           if (contentX == self.ceLanWidth) {
            
                [self.delegate didClose];
        
             }
        }

   }
    
    self.isDidScroll = NO;
}


/*
 * 自动开启
 */
- (void)ziDongKaiQiAnimated:(BOOL)animated{
    
    //执行开启代理方法
    self.isBeginDragging = NO;

    if (self.delegate && [self.delegate respondsToSelector:@selector(willOpen)]) {
        
        [self.delegate willOpen];
    }
    
    if (animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width, K_Height);
            
            self.superScrollView.contentOffset = CGPointMake(0, - _zhuangTaiY);
            
        } completion:^(BOOL finished) {
            
        if (self.delegate && [self.delegate respondsToSelector:@selector(didOpen)]) {
            
            [self.delegate didOpen];
            
        }
            
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
    self.isBeginDragging = NO;
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(willClose)]) {
        
        [self.delegate willClose];
    }
    
    if (animated) {
     
        [UIView animateWithDuration:0.3 animations:^{
            
            self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width + self.ceLanWidth, K_Height);
            
            self.superScrollView.contentOffset = CGPointMake(self.ceLanWidth, - _zhuangTaiY);
            
        } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClose)]) {
            
            [self.delegate didClose];
            
        }
            
        }];
        
    }else {
        
        self.ceView.frame = CGRectMake(0, - _zhuangTaiY, K_Width + self.ceLanWidth, K_Height);
        
        self.superScrollView.contentOffset = CGPointMake(self.ceLanWidth, - _zhuangTaiY);
        
        [self.delegate didClose];
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
