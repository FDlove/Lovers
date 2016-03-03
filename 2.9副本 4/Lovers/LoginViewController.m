//
//  LoginViewController.m
//  Lovers
//
//  Created by student on 15/12/23.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
@interface LoginViewController ()<UIAlertViewDelegate>
{
   // int login;
}
@property BOOL exist;
- (IBAction)returnAction:(id)sender;
- (IBAction)LoadAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTF;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTF;
@property (weak, nonatomic) IBOutlet UIButton *LoadButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation LoginViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exist=NO;//记录是否为注销状态
    
    [self setCornerRadius];//设置按钮等部件圆角
    [self.imageView setImage:[UIImage imageNamed:@"Loginbackground"]];
    
    NSLog(@"-----reg-----%@",self.navigationController);
    // Do any additional setup after loading the view.
}
-(void)setCornerRadius
{
    [self.LoadButton.layer setCornerRadius:5.0];
    [self.ReturnButton.layer setCornerRadius:5.0];
    [self.UserNameTF.layer setCornerRadius:5.0];
    [self.PassWordTF.layer setCornerRadius:5.0];
    [self.backgroundView.layer setCornerRadius:5.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)returnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)LoadAction:(id)sender {

    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Users"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            NSString *username= [obj objectForKey:@"UserName"];
            NSString *password=[obj objectForKey:@"PassWord"];
            if ([self.UserNameTF.text isEqualToString:username]&&[self.PassWordTF.text isEqualToString:password]) {
                self.exist=YES;
            }
            
        }
        if (self.exist==NO) {
            //账号有误提示窗
            UIAlertController*alert =[UIAlertController alertControllerWithTitle:@"您的账号有误！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            

        }else{
            //判断是否已经绑定另一半，若绑定则进入主界面  若未绑定 则进入绑定界面
            
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Users"];
            
            [bquery whereKey:@"UserName" equalTo:self.UserNameTF.text];
            
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count==0) {
                    NSLog(@"用户不存在");
                    
                }else{
                    NSLog(@"%@",array);
                    for (BmobObject *obj in array) {
                        NSLog(@"%@",[obj objectForKey:@"myLovers"]);
                        
                        if (![obj objectForKey:@"myLovers"]|| [[obj objectForKey:@"myLovers"]isEqualToString:@""]) {
                            [self showTextFieldUIAlertView];
//                            
                        }else{
                         //   发送已登录通知 给主界面传参数UserName
                                        NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
                            
                                        [de setObject:self.UserNameTF.text forKey:@"username"];
                                        NSLog(@"%@",self.UserNameTF.text);
                                        [self loginMain];
                        }
                    }
                }
            }];

            
            

        }
    }];
   
    
}
-(void)loginMain
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    UIStoryboard *storybd=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *mainVC=[storybd instantiateViewControllerWithIdentifier:@"mainVC"];
    app.window.rootViewController=mainVC;
}

- (void)showTextFieldUIAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请绑定另一半用户名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alertView show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *txt = [alertView textFieldAtIndex:0];
    
    if (buttonIndex == 1) //确定
    {
        if (txt.text.length > 0)
        {
            //存入另一半用户名信息
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Users"];
            [bquery whereKey:@"UserName" equalTo:self.UserNameTF.text];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count==0) {
                    NSLog(@"用户不存在");
                }else{
                    for (BmobObject *obj in array) {
                        [obj setObject:txt.text forKey:@"myLovers"];
                        [obj updateInBackground];
                        [self.view makeToast:@"绑定成功，请登录！" duration:2 position:@"CSToastPositionCenter"];
                    }
                }
            }];
            
        }else{
            [self.view makeToast:@"用户名不能为空" duration:2 position:@"CSToastPositionCenter"];
            
        }
    }
}
@end
