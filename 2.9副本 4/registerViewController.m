//
//  registerViewController.m
//  Lovers
//
//  Created by student on 15/12/23.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "registerViewController.h"
#import "LoginViewController.h"
#import "UIView+Toast.h"

@interface registerViewController ()

- (IBAction)returnAction:(id)sender;
@property BOOL exist;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTF;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *PassWordagainTF;
@property (weak, nonatomic) IBOutlet UIButton *registerAction;
@property (weak, nonatomic) IBOutlet UIImageView *backimageView;
@property (weak, nonatomic) IBOutlet UIView *backButtonView;
- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *identifierCodeTF;
- (IBAction)GetIdentifierCodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getIDCodeButton;

@end

@implementation registerViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exist=NO;
    [self.backimageView setImage:[UIImage imageNamed:@"back02"]];
    [self.backButtonView.layer setCornerRadius:10.0];
    [self.registerButton.layer setCornerRadius:5.0];
    [self.returnButton.layer setCornerRadius:5.0];
    [self.getIDCodeButton.layer setCornerRadius:5.0];
   //键盘遮挡界面通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardwillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardwillHidden:) name:UIKeyboardWillHideNotification object:nil];
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

- (IBAction)returnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)registerAction:(id)sender {
    //判断用户名是否为空
    if ([self.UserNameTF.text isEqualToString:@""]) {
        //用户名不能为空提示穿
        
        [self.view makeToast:@"用户名不能为空" duration:2 position:@"CSToastPositionCenter"];
    }else{
    
    }
    //判断用户名是否为空
    if ([self.UserNameTF.text isEqualToString:@""]) {
        //用户名不能为空提示穿

        [self.view makeToast:@"用户名不能为空" duration:2 position:@"CSToastPositionCenter"];
        
        
    }else//判断密码是否为空
        if([self.PassWordTF.text isEqualToString:@""]){
            //密码不能为空提示窗

            [self.view makeToast:@"密码不能为空" duration:2 position:@"CSToastPositionCenter"];
            
        
    }else{
        //判断两次密码是否相同
        if ([self.PassWordTF.text isEqualToString:self.PassWordagainTF.text]) {
            //查询Users表中的所有数据
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Users"];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
             {
                 NSLog(@"%@",array);
                 for (BmobObject *obj in array)
                 {
                     NSString *username=[obj objectForKey:@"UserName"];
                    
                     if ([self.UserNameTF.text isEqualToString:username])
                     {
                         self.exist=YES;
                     }
                     
                 }
                 [self Verification];
             }];
            
            
        }else{
            //密码不一致提示窗
            [self.view makeToast:@"密码不一致" duration:2 position:@"CSToastPositionCenter"];
            

        }
        
        
    }
}
-(void)Verification
{
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.UserNameTF.text andSMSCode:self.identifierCodeTF.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"%@",@"验证成功，可执行用户请求的操作");
            [self existAction];
            
        } else {
            NSLog(@"%@",error);
            
        }
    }];
}
-(void)existAction
{
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.UserNameTF.text andSMSCode:self.identifierCodeTF.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"%@",@"验证成功，可执行用户请求的操作");
            
        } else {
              [self.view makeToast:@"您的验证码有误！" duration:2 position:@"CSToastPositionCenter"];
        }
    }];
    //判断是否存在账号 若没有创建  有重新输入
    if (self.exist==NO) {
        
        BmobObject *UserOBJ = [BmobObject objectWithClassName:@"Users"];
        [UserOBJ setObject:self.UserNameTF.text forKey:@"UserName"];
        [UserOBJ setObject:self.PassWordTF.text forKey:@"PassWord"];
        [UserOBJ setObject:@"" forKey:@"myLover"];
        [UserOBJ setObject:nil forKey:@"headImage"];
        [UserOBJ saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            //注册成功提示窗
            UIAlertController*alert =[UIAlertController alertControllerWithTitle:@"注册成功，快去登录吧！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        
        
        
    }else{
        //账号已存在提示窗
        self.exist=NO;

        [self.view makeToast:@"您的账号已存在，请直接登录！" duration:2 position:@"CSToastPositionCenter"];
        
        
    }
    
}

- (IBAction)GetIdentifierCodeAction:(id)sender {
    if ([self.UserNameTF.text isEqualToString:@""]) {
        //用户名不能为空提示穿
        
        [self.view makeToast:@"用户名不能为空" duration:2 position:@"CSToastPositionCenter"];
    }else{
        //获取验证码

        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.UserNameTF.text andTemplate:nil resultBlock:^(int number, NSError *error) {
            if (error)
            {
                NSLog(@"%@",error);
            } else{
                //获得smsID
                    NSLog(@"sms ID：%d",number);
                [self.view makeToast:@"验证码已发送" duration:2 position:@"CSToastPositionCenter"];
                }
        }];
        
    }
    
        
    
}

//键盘遮挡画面时移动vIew
-(NSInteger)findFirstResponsder
{
    for (UIView *view in [self.view subviews]) {
        if ([view isFirstResponder]) {
            return  view.tag;
        }
    }
    return -2;
}
-(void)keyboardwillShow:(NSNotification *)noti
{
    UITextField *textfield=(UITextField *)[self.view viewWithTag:[self findFirstResponsder]];
    NSValue *tmpvalue =[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[tmpvalue CGRectValue];
    
    CGFloat keyboard_height=frame.size.height;
    CGFloat off_set= CGRectGetMaxY(textfield.frame)-(winHeight-keyboard_height);
    if (winHeight-keyboard_height<(CGRectGetMaxY(textfield.frame))) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform=CGAffineTransformMakeTranslation(0, -off_set);
        }];
        
    }
}
-(void)keyboardwillHidden:(NSNotification *)noti
{
    self.view.transform=CGAffineTransformIdentity;
}
@end
