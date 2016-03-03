//
//  ChangeLoverViewController.m
//  Lovers
//
//  Created by student on 16/1/14.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "ChangeLoverViewController.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CPKenburnsView.h"
@interface ChangeLoverViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *Canclehub;
    MBProgressHUD *hubUser;
    MBProgressHUD *hubLover;
}
@property (weak, nonatomic) IBOutlet UIImageView *LoversImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *LoverImageView;
@property(nonatomic,strong)NSString *UserName;
@property(nonatomic,strong)NSString *LoverName;
@property(nonatomic,strong)NSString *belongName;
- (IBAction)CancleLovers:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CancleButton;

@end

@implementation ChangeLoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CPKenburnsView *kenburnsView = [[CPKenburnsView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    kenburnsView.image = [UIImage imageNamed:@"CancleLoversBackImage"];
    
    [self.view addSubview:kenburnsView];
    
    //定义用退出按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchDown];
    backButton.layer.cornerRadius = CGRectGetHeight(backButton.bounds) / 2;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=bu;
    
    
    
    
    hubUser=[[MBProgressHUD alloc]initWithView:self.view];
    hubUser.delegate=self;
    hubUser.labelText=@"正在加载你的头像！请稍后...";
    [self.view addSubview:hubUser];
    
    hubLover=[[MBProgressHUD alloc]initWithView:self.view];
    hubLover.delegate=self;
    hubLover.labelText=@"正在加载对方头像！请稍后...";
    [self.view addSubview:hubLover];
    
    Canclehub=[[MBProgressHUD alloc]initWithView:self.view];
    Canclehub.delegate=self;
    Canclehub.labelText=@"正在解除Lover关系，请稍后。。。";
    [self.view addSubview:Canclehub];
    
    
    
   // self.userImageView=[[UIImageView alloc]init];
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView.layer setCornerRadius:self.userImageView.bounds.size.width/2];
    self.LoverImageView.layer.masksToBounds = YES;
    [self.LoverImageView.layer setCornerRadius:self.userImageView.bounds.size.width/2];

    [self.view bringSubviewToFront:self.userImageView];
    [self.view bringSubviewToFront:self.LoverImageView];
    
    [self.view bringSubviewToFront:self.LoversImage];
    [self.view bringSubviewToFront:self.CancleButton];
    //获取用户头像
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    self.UserName=[def objectForKey:@"username"];
    self.LoverName=[def objectForKey:@"loversName"];
    self.belongName=[def objectForKey:@"belongName"];
    
    
    [self loadUserHeadImage];
 
  
    // Do any additional setup after loading the view.
}
-(void)loadUserHeadImage
{
    [hubUser show:YES];
    //在Users中查询用户的头像
    BmobQuery *query=[BmobQuery queryWithClassName:@"Users"];
    [query whereKey:@"UserName" equalTo:self.UserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            
        }else{
        
            for (BmobObject *obj in array) {
                BmobFile *file=[obj objectForKey:@"headimage"];
                [self.userImageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
                [hubUser hide:YES];
                [self loadLoverHeadImage];
            }
        }
        
    }];
    
}
-(void)loadLoverHeadImage
{
    [hubLover show:YES];
    //在Users中查询lovers的头像
    BmobQuery *query=[BmobQuery queryWithClassName:@"Users"];
    [query whereKey:@"UserName" equalTo:self.LoverName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            
        }else{
            
            for (BmobObject *obj in array) {
                BmobFile *file=[obj objectForKey:@"headimage"];
                [self.LoverImageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
                [hubLover hide:YES];
            }
        }
        
    }];
}

-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)CancleLovers:(id)sender {
    
    //是否删除Lover提示窗
    UIAlertController*alert =[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你真的要与%@说分手吗?",self.LoverName] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"我特么手贱" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
       
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"没爱了！" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self isCancle];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)isCancle
{
    [Canclehub show:YES];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Users"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            
        }else{
            
            for (BmobObject *obj in array) {
                if ([[obj objectForKey:@"UserName"] isEqualToString:self.UserName]) {
                    [obj setObject:@"" forKey:@"myLovers"];
                    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [Canclehub hide:YES];
                            AppDelegate *app=[UIApplication sharedApplication].delegate;
                            UIStoryboard *storybd=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            UINavigationController *mainVC=[storybd instantiateViewControllerWithIdentifier:@"PrepareVC"];
                            app.window.rootViewController=mainVC;
                        }
                    }];
                }
            }
        }
    }];
    

}
@end
