//
//  SpeakViewController.m
//  Lovers
//
//  Created by student on 16/1/21.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "SpeakViewController.h"

@interface SpeakViewController ()

@end

@implementation SpeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //定义用退出按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchDown];
    backButton.layer.cornerRadius = CGRectGetHeight(backButton.bounds) / 2;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=bu;
   
    // Do any additional setup after loading the view.
}
-(void)backView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
