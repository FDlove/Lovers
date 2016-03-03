//
//  ShopViewController.m
//  Lovers
//
//  Created by student on 15/12/28.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "ShopViewController.h"
#import "ClickImage.h"
@interface ShopViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Snip20151228_1"] forBarMetrics:UIBarMetricsDefault];
    //定义titleview
    UIView *titileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [label1 setText:@"商城"];
    label1.textColor=[UIColor whiteColor];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:18]];
    [titileView addSubview:label1];
    self.navigationItem.titleView = titileView;
    
    
    
    // Do any additional setup after loading the view.
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
