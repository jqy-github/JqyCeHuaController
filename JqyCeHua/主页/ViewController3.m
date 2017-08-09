//
//  ViewController3.m
//  Ios侧滑
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import "ViewController3.h"

#import "JqyCeHuaController.h"

@interface ViewController3 ()<UIScrollViewDelegate>
{
    CGPoint scrollContent;
}

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *dd = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height  - 49 )];
    dd.pagingEnabled = YES;
    dd.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *3, [UIScreen mainScreen].bounds.size.height -49 - 64);
    dd.bounces = NO;
    dd.showsHorizontalScrollIndicator = NO;
    dd.delegate = self;
    [self.view addSubview:dd];
    
    UIImageView *cc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49- 64)];
    cc.image = [[UIImage imageNamed:@"141e05607ea35fcba3d0b4a8b6c82abd.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *cc2 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49- 64)];
    cc2.image = [[UIImage imageNamed:@"75ba7d4706523eaa8582b3144916f6db.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *cc3 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49- 64)];
    cc3.image = [[UIImage imageNamed:@"c97e521f16f1d8e825f6fb9eaba6bf52.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [dd addSubview:cc];
    [dd addSubview:cc2];
    [dd addSubview:cc3];

    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
#warning 防止手势冲突产生的bug
    if (Jqy_ceHuaVc.isDianJiCeHuaQu) {
        
        scrollView.contentOffset = scrollContent;
    }
    
//    scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, -64);
    
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    scrollContent = scrollView.contentOffset;
    
    
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
