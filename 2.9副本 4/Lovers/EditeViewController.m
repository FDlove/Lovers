//
//  EditeViewController.m
//  Lovers
//
//  Created by student on 16/1/19.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "EditeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface EditeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ShowButton;
@property (weak, nonatomic) IBOutlet UILabel *ContextLabel;
@property (weak, nonatomic) IBOutlet UILabel *DayNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
- (IBAction)ShowAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *BackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *CDBanView;

@end

@implementation EditeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:2433/255.0 green:213/255.0 blue:184/255.0 alpha:1.0]];
    self.ContextLabel.text=self.model.Context;
    self.DayNumberLabel.text=self.model.Daynumber;
    self.DateLabel.text=self.model.Date;
  
    
    
    //self.BackImageView.layer.masksToBounds = YES;
    [self.BackImageView.layer setCornerRadius:5.0];
    [self.BackImageView setImage:[UIImage imageNamed:@"muban"]];
    self.ContextLabel.layer.masksToBounds=YES;
    [self.ContextLabel.layer setCornerRadius:5.0];
    [self.ShowButton.layer setCornerRadius:5.0];
    
    
    
    //定义删除按钮
    UIButton *buttonOther=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [buttonOther setImage:[UIImage imageNamed:@"block"] forState:UIControlStateNormal];
    [buttonOther addTarget:self action:@selector(deleteModel) forControlEvents:UIControlEventTouchDown];
    buttonOther.layer.borderWidth=2;
    buttonOther.layer.borderColor=[UIColor whiteColor].CGColor;
    buttonOther.layer.cornerRadius = CGRectGetHeight(buttonOther.bounds) / 2;
    buttonOther.clipsToBounds = YES;
    UIBarButtonItem *buOther=[[UIBarButtonItem alloc]initWithCustomView:buttonOther];
    self.navigationItem.rightBarButtonItem=buOther;

    
    //定义退出按钮
    UIButton *backbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backbutton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchDown];
    backbutton.layer.borderWidth=2;
    backbutton.layer.borderColor=[UIColor whiteColor].CGColor;
    backbutton.layer.cornerRadius = CGRectGetHeight(buttonOther.bounds) / 2;
    backbutton.clipsToBounds = YES;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=bu;

    
    
    // Do any additional setup after loading the view.
}
-(void)backVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)deleteModel
{
    //点击删除是否删除提示窗
    UIAlertController*alert =[UIAlertController alertControllerWithTitle:@"是否删除本条记录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //删除数据
        [UIView animateWithDuration:0.7 delay:0 options:0 animations:^(){
            [self.delegate CancleCDData:self.model.index];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } completion:^(BOOL finished)
         {
             
         }];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
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
//获得屏幕截图
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
- (IBAction)ShowAction:(id)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"测试：我是来自Lovers的一条分享"
                                     images:@[[self imageFromView:self.view atFrame:CGRectMake(0, 0, winWidth, winHeight)]]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeImage];
    
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}
@end
