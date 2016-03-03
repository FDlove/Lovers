//
//  TabBarViewController.m
//  Lovers
//
//  Created by student on 16/1/19.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor=[UIColor colorWithRed:135/255.0 green:33/255.0 blue:32/255.0 alpha:1.0] ;
    UIImage *image0 = [UIImage imageNamed:@"时光Item"];
   // image0 = [image0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//禁止渲染  如果不禁止会被系统蓝色所渲染  在sb中设置selectedImage也是一样会被渲染
    NSLog(@"%@",self.viewControllers);
    [[self.viewControllers objectAtIndex:0].tabBarItem setImage:image0];
    [[self.viewControllers objectAtIndex:0].tabBarItem setSelectedImage:[UIImage imageNamed:@"时光ItemSelected"]];
    
    
    UIImage *image1 = [UIImage imageNamed:@"纪念日Item"];
    //image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//禁止渲染  如果不禁止会被系统蓝色所渲染  在sb中设置selectedImage也是一样会被渲染
    NSLog(@"%@",self.viewControllers);
    [[self.viewControllers objectAtIndex:1].tabBarItem setImage:image1];
    [[self.viewControllers objectAtIndex:1].tabBarItem setSelectedImage:[UIImage imageNamed:@"纪念日ItemSelected"]];
    
    UIImage *image2 = [UIImage imageNamed:@"商城Item"];
    //image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//禁止渲染  如果不禁止会被系统蓝色所渲染  在sb中设置selectedImage也是一样会被渲染
    NSLog(@"%@",self.viewControllers);
    [[self.viewControllers objectAtIndex:2].tabBarItem setImage:image2];
    [[self.viewControllers objectAtIndex:2].tabBarItem setSelectedImage:[UIImage imageNamed:@"商城ItemSelected"]];
    
    UIImage *image3 = [UIImage imageNamed:@"空间Item"];
   // image3 = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//禁止渲染  如果不禁止会被系统蓝色所渲染  在sb中设置selectedImage也是一样会被渲染
    NSLog(@"%@",self.viewControllers);
    [[self.viewControllers objectAtIndex:3].tabBarItem setImage:image3];
    [[self.viewControllers objectAtIndex:3].tabBarItem setSelectedImage:[UIImage imageNamed:@"空间ItemSelected"]];
   
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //改变字体选中颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:135/255.0 green:33/255.0 blue:32/255.0 alpha:1.0]} forState:UIControlStateSelected];

    //改变普通状态下字体的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}forState:UIControlStateNormal];
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
