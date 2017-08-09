//
//  ViewController.m
//  JqyCeHua
//
//  Created by 开发者 on 2017/8/4.
//  Copyright © 2017年 J丶Qy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImv = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backImv.image = [[UIImage imageNamed:@"bab7a3fd7e3996bd0556650d5e5ed865.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.view addSubview:backImv];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
