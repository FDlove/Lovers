//
//  PrepareViewController.m
//  Lovers
//
//  Created by student on 15/12/28.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "PrepareViewController.h"
#import "AppDelegate.h"
#import "registerViewController.h"
@interface PrepareViewController ()<UIScrollViewDelegate>
{
    NSTimer *timer;
    BOOL changedYes;
}
- (IBAction)registerAction:(id)sender;
- (IBAction)LoginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *mypageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *myLoginScollView;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@property (weak, nonatomic) IBOutlet UIView *registbuttonView;
@property (weak, nonatomic) IBOutlet UIView *loginbuttonView;

@end

@implementation PrepareViewController
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
   
    timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scollchangeImage) userInfo:nil repeats:YES];
    
    
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    changedYes=YES;
    [self.registButton.layer setCornerRadius:5.0];
    [self.LoginButton.layer setCornerRadius:5.0];
    [self.registbuttonView.layer setCornerRadius:5.0];
    [self.loginbuttonView.layer setCornerRadius:5.0];
    
    
    self.myLoginScollView.userInteractionEnabled=YES;
    
    [self.myLoginScollView setContentSize:CGSizeMake(320*5, 568)];
    self.mypageControl.numberOfPages=5;
    
    
    for (int i =0; i<5; i++) {
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*winWidth, 0, winWidth, winHeight)];
        [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"back0%i.jpg",i]]];
        [self.myLoginScollView addSubview:imageview];
    }
    [self.myLoginScollView setContentSize:CGSizeMake(winWidth*5, winHeight)];
   // self.myLoginScollView.showsVerticalScrollIndicator = NO;
    self.myLoginScollView.pagingEnabled = YES;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)scollchangeImage
{
//    if () {
//        <#statements#>
//    }
//    
    if (self.myLoginScollView.contentOffset.x==winWidth*4) {
        changedYes=NO;
    }
    if (self.myLoginScollView.contentOffset.x==0) {
        changedYes=YES;
    }
    if (changedYes) {
        [UIView animateWithDuration:1 animations:^{
            self.myLoginScollView.contentOffset = CGPointMake(self.myLoginScollView.contentOffset.x+winWidth, 0);
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.myLoginScollView.contentOffset = CGPointMake(self.myLoginScollView.contentOffset.x-winWidth,0);
        }];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设置pagecontrol的当前页
    self.mypageControl.currentPage =scrollView.contentOffset.x/winWidth;
}

//即将开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [timer invalidate];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scollchangeImage) userInfo:nil repeats:YES];
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

- (IBAction)registerAction:(id)sender {
    [timer invalidate];
    
}

- (IBAction)LoginAction:(id)sender {
    [timer invalidate];
    
    [self performSegueWithIdentifier:@"LoginAction" sender:nil];
    

}
@end
