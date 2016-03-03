//
//  AboutViewController.m
//  Lovers
//
//  Created by student on 16/1/21.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *AboutLoverLabel;
@property (weak, nonatomic) IBOutlet UILabel *AboutUs;
@property (weak, nonatomic) IBOutlet UILabel *OurgoalLabel;
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *Label2;
@property (weak, nonatomic) IBOutlet UILabel *Label3;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //定义用退出按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchDown];
    backButton.layer.cornerRadius = CGRectGetHeight(backButton.bounds) / 2;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=bu;
    
    self.AboutLoverLabel.text=@"Lovers是一款专门为相爱的情侣们打造的集记录，分享，纪念，购物，娱乐，社交于一体的情侣软件。在这里，你可以与你相爱的人共同打造属于你们的专属空间，记录着情侣们一路走来的点点滴滴，温馨且感动；在这里你可以分享你与爱人之间的秘密，有趣且俏皮；在这里，你可以留下你们的纪念日，可以选购一款情侣物件，可以一起交流娱乐。。。。在这里只有你想不到的，没有我们做不到的。Lovers--只要有你陪！";
    [self.AboutLoverLabel setFont:[UIFont systemFontOfSize:10.0]];
    CGFloat AboutLoverLabel_y=CGRectGetMaxY(self.Label2.frame)-30;
    self.AboutLoverLabel.numberOfLines = 0;
    CGSize AboutLoverLabel_size = [self.AboutLoverLabel sizeThatFits:CGSizeMake(100, MAXFLOAT)];
//    CGSize AboutLoverLabel_size = [self.AboutLoverLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [self.AboutLoverLabel setFrame:CGRectMake(10, AboutLoverLabel_y, AboutLoverLabel_size.width, AboutLoverLabel_size.height)];
    
    self.AboutUs.text=@"我只是这世界上众多情侣中的一员，我只是致力于打造一款属于我们自己的软件，在这款软件中完成我们想要完成的一切。";
    [self.AboutUs setFont:[UIFont systemFontOfSize:10.0]];
    self.AboutUs.numberOfLines = 0;
    CGFloat AboutUs_y=CGRectGetMaxY(self.Label1.frame)-30;
    CGSize AboutUs_size = [self.AboutUs.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [self.AboutUs setFrame:CGRectMake(10, AboutUs_y, AboutUs_size.width, AboutUs_size.height)];
    
    
    self.OurgoalLabel.text=@"为世界上的所有爱人们打造一款有你们想要的一切的软件。";
    [self.OurgoalLabel setFont:[UIFont systemFontOfSize:10.0]];
    self.OurgoalLabel.numberOfLines = 0;
    CGFloat OurgoalLabel_y=CGRectGetMaxY(self.Label3.frame)-30;
    CGSize OurgoalLabel_size = [self.OurgoalLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [self.OurgoalLabel setFrame:CGRectMake(10, OurgoalLabel_y, OurgoalLabel_size.width, OurgoalLabel_size.height)];
    
    
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
