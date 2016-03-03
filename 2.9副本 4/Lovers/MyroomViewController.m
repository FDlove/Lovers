//
//  MyroomViewController.m
//  Lovers
//
//  Created by student on 15/12/28.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "MyroomViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "PersonalModel.h"
@interface MyroomViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //头像按钮
    UIButton *headButton;
    //用户名
    UILabel *NameLabel;
    //时光数量
    UILabel *TimesLabel;
    //纪念日数量
    UILabel *CDLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)PersonalModel *personModel;
@end

@implementation MyroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Snip20151228_1"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden=NO;
    UIView *headeView=[[UIView alloc]init];
    
    //定义titleview
    UIView *titileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [label1 setText:@"我的"];
    label1.textColor=[UIColor whiteColor];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:18]];
    [titileView addSubview:label1];
    self.navigationItem.titleView = titileView;
    
    
    //头像按钮
    headButton=[[UIButton alloc]init];
    [headButton setFrame:CGRectMake(10, 10, 40, 40)];
    [headButton setBackgroundColor:[UIColor lightGrayColor]];
    headButton.layer.masksToBounds=YES;
    [headButton.layer setCornerRadius: CGRectGetHeight(headButton.bounds) / 2];
    [headButton addTarget:self action:@selector(GoPersonal) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    [headeView addSubview:headButton];
    
    //用户名
    NameLabel=[[UILabel alloc]init];
    [NameLabel setFont:[UIFont systemFontOfSize:15]];
    NameLabel.text=@"我的名字";
    CGFloat NameLabel_x=CGRectGetMaxX(headButton.frame)+5;
    CGFloat NameLabel_y=CGRectGetMaxY(headButton.frame)/2;
    CGSize NameLabel_size = [NameLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    [NameLabel setFrame:CGRectMake(NameLabel_x, NameLabel_y, NameLabel_size.width, NameLabel_size.height)];
    [headeView addSubview:NameLabel];
    
    //获取用户名 并且设置头像
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.username=[defaults objectForKey:@"username"];
    [self setHeaderButtonImage];

    
    //扫一扫按钮
    UIButton *scanButton=[[UIButton alloc]init];
    //[scanButton setBackgroundColor:[UIColor redColor]];
    [scanButton setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [scanButton setFrame:CGRectMake(winWidth-40, NameLabel_y, 30 , 30)];
    [scanButton addTarget:self action:@selector(ScanAction) forControlEvents:UIControlEventTouchDown];
    [headeView addSubview:scanButton];
    
    UIView *line=[[UIView alloc]init];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [line setFrame:CGRectMake(10, CGRectGetMaxY(headButton.frame)+10, winWidth-20, 1)];
    [headeView addSubview:line];
    
    UIView *line1=[[UIView alloc]init];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [line1 setFrame:CGRectMake(winWidth/3, CGRectGetMaxY(line.frame)+10, 1, 30)];
    [headeView addSubview:line1];
    
    UIView *line2=[[UIView alloc]init];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [line2 setFrame:CGRectMake(winWidth/3*2, CGRectGetMaxY(line.frame)+10, 1, 30)];
    [headeView addSubview:line2];
    
    
    //时光button
    UIButton *TimesButton=[[UIButton alloc]init];
    //[Button1 setBackgroundColor:[UIColor redColor]];
    [TimesButton setBackgroundImage:[UIImage imageNamed:@"时光"] forState:UIControlStateNormal];
    [TimesButton setFrame:CGRectMake(winWidth/3/2-10, CGRectGetMaxY(line1.frame)-30/2-10, 20, 20)];
    [TimesButton addTarget:self action:@selector(TimesAction) forControlEvents:UIControlEventTouchDown];
    [headeView addSubview:TimesButton];
    
    //时光数据量Label
    TimesLabel=[[UILabel alloc]init];
    [self setTimersNumberLabelText];
    TimesLabel.textColor=[UIColor lightGrayColor];
    [TimesLabel setFont:[UIFont systemFontOfSize:10]];
    CGFloat TimesLabel_y=CGRectGetMaxY(TimesButton.frame);
    CGSize TimesLabel_size=[TimesLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [TimesLabel setFrame:CGRectMake(winWidth/3/2-TimesLabel_size.width/2, TimesLabel_y, TimesLabel_size.width, TimesLabel_size.height)];
    [headeView addSubview:TimesLabel];
    
    //纪念日Button
    UIButton *CDButton=[[UIButton alloc]init];
   // [Button2 setBackgroundColor:[UIColor redColor]];
    [CDButton setBackgroundImage:[UIImage imageNamed:@"纪念日"] forState:UIControlStateNormal];
    [CDButton setFrame:CGRectMake(winWidth/3+winWidth/3/2-10, CGRectGetMaxY(line1.frame)-30/2-10, 20, 20)];
    [CDButton addTarget:self action:@selector(CDAction) forControlEvents:UIControlEventTouchDown];
    [headeView addSubview:CDButton];
    
    //纪念日数据量Label
    CDLabel=[[UILabel alloc]init];
    CDLabel.text=@"261";
    CDLabel.textColor=[UIColor lightGrayColor];
    [CDLabel setFont:[UIFont systemFontOfSize:10]];
    CGFloat CDLabel_y=CGRectGetMaxY(TimesButton.frame);
    CGSize CDLabel_size=[TimesLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [CDLabel setFrame:CGRectMake(winWidth/3+winWidth/3/2-CDLabel_size.width/2, CDLabel_y, CDLabel_size.width, CDLabel_size.height)];
    [headeView addSubview:CDLabel];
    
    
    //购物车button
    UIButton *ShopCarButton=[[UIButton alloc]init];
    //[Button3 setBackgroundColor:[UIColor redColor]];
    [ShopCarButton setBackgroundImage:[UIImage imageNamed:@"纪念日"] forState:UIControlStateNormal];
    [ShopCarButton setFrame:CGRectMake(winWidth/3*2+winWidth/3/2-10, CGRectGetMaxY(line1.frame)-30/2-10, 20, 20)];
    [ShopCarButton addTarget:self action:@selector(ShopCarAction) forControlEvents:UIControlEventTouchDown];
    [headeView addSubview:ShopCarButton];
    
    //购物车数据量Label
    UILabel *ShopCarLabel=[[UILabel alloc]init];
    ShopCarLabel.text=@"261";
    ShopCarLabel.textColor=[UIColor lightGrayColor];
    [ShopCarLabel setFont:[UIFont systemFontOfSize:10]];
    CGFloat ShopCarLabel_y=CGRectGetMaxY(TimesButton.frame);
    CGSize ShopCarLabel_size=[ShopCarLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [ShopCarLabel setFrame:CGRectMake(winWidth/3*2+winWidth/3/2-ShopCarLabel_size.width/2, ShopCarLabel_y, ShopCarLabel_size.width, ShopCarLabel_size.height)];
    [headeView addSubview:ShopCarLabel];
    
  
    [self.view setBackgroundColor:[UIColor colorWithRed:233/255.0 green:213/255.0 blue:184/255.0 alpha:1.0]];
    
    
    

    
    [headeView setFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(line2.frame)+10)];
    self.myTableView.tableHeaderView=headeView;
    
    
    self.myTableView.tableFooterView=[[UIView alloc]init];
    [self.myTableView.tableFooterView setBackgroundColor:[UIColor colorWithRed:233/255.0 green:213/255.0 blue:184/255.0 alpha:1.0]];
    
    //设置用户名
    [self  setNameLabelText];
    
    [self setUprefresh];
    // Do any additional setup after loading the view.
}
-(void)GoPersonal
{
    [self performSegueWithIdentifier:@"gopersonal" sender:nil];
}
//设置用户名
-(void)setNameLabelText
{
    //获取归属名
    NSUserDefaults *de  =[NSUserDefaults standardUserDefaults];
    [de objectForKey:@"belongName"];
    
    PersonalModel *personalModel=[[PersonalModel alloc]init];
    [personalModel loadStatusData:[de objectForKey:@"belongName"]];
    personalModel.returnBlock=^(id result)
    {
        self.personModel=result;
        NameLabel.text=self.personModel.Name;
    };
}
-(void)setTimersNumberLabelText
{
    NSUserDefaults *dff=[NSUserDefaults standardUserDefaults];
    
      TimesLabel.text= [dff objectForKey:@"TimersNumber"];
}
-(void)setCDNumberLabelText
{
    NSUserDefaults *dff=[NSUserDefaults standardUserDefaults];
    
    CDLabel.text= [dff objectForKey:@"CDNumber"];
}
//设置头像图片
-(void)setHeaderButtonImage
{
    //先查PersonalInfo表 如果没有数据 则创建初始化头像  如果有数据但是[obj objectforkey:@"headImage"]为空则创建初始化头像 若有数据且[obj objectforkey:@"headImage"]有图片 则设置图片
    BmobQuery *query=[BmobQuery queryWithClassName:@"Users"];
    
    [query whereKey:@"UserName" equalTo:self.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            [headButton setBackgroundImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
           
            
        }else{
            
            for (BmobObject *obj in array) {
                BmobFile *file=[obj objectForKey:@"headimage"];
                if (file.url) {
                    
                    [headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:file.url] forState:UIControlStateNormal];
                    [headButton.layer setCornerRadius: CGRectGetHeight(headButton.bounds) / 2];
//                    [self headerRefresh];
                 
                }else{
                    [headButton setBackgroundImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
                    
                }
            }
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identidier=@"MRcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identidier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identidier];
        cell.textLabel.textColor=[UIColor grayColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section==0) {
            [cell.imageView setImage:[UIImage imageNamed:@"历史记录"]];
            cell.textLabel.text=@"历史订单";
        }else if(indexPath.section==1){
            [cell.imageView setImage:[UIImage imageNamed:@"管理地址"]];
            cell.textLabel.text=@"管理地址";
        }else if(indexPath.section==2){
            [cell.imageView setImage:[UIImage imageNamed:@"帮助反馈"]];
            cell.textLabel.text=@"帮助反馈";
        }else if (indexPath.section==3){
        
            [cell.imageView setImage:[UIImage imageNamed:@"设置-1"]];
            cell.textLabel.text=@"设置";
        }
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, winWidth, 20)];
    [view setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){
        [self performSegueWithIdentifier:@"historyOrder" sender:nil];
    }
    if (indexPath.section==1) {
        [self performSegueWithIdentifier:@"manageAdress" sender:nil];
    }
    if (indexPath.section==2) {
        [self performSegueWithIdentifier:@"helpfeedback" sender:nil];
    }
    if (indexPath.section==3) {
        [self performSegueWithIdentifier:@"Setting" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}


//点击扫一扫按钮
-(void)ScanAction
{
}
//点击时光按钮
-(void)TimesAction
{
    self.tabBarController.selectedIndex=0;
}
//点击纪念日按钮
-(void)CDAction
{
    self.tabBarController.selectedIndex=1;
}
//点击点击购物车按钮
-(void)ShopCarAction
{
}



#pragma mark-MJRefresh
-(void)setUprefresh
{
    
    
    [self.myTableView   addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    
    [self.myTableView   addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.myTableView  headerBeginRefreshing];
    
    
    [self.myTableView  setHeaderPullToRefreshText:@"下拉.."];
    [self.myTableView   setHeaderReleaseToRefreshText:@"请松手..."];
    [self.myTableView   setHeaderRefreshingText:@"正在刷新.."];
    
    [self.myTableView  setFooterPullToRefreshText:@"上拉.."];
    [self.myTableView   setFooterReleaseToRefreshText:@"请松手..."];
    [self.myTableView   setFooterRefreshingText:@"正在刷新.."];
    
}

-(void)headerRefresh
{
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [self setHeaderButtonImage];
        [self setNameLabelText];
        [self setCDNumberLabelText];
        [self.myTableView  headerEndRefreshing];
//    });
    
}

/**
 上拉加载更多
 */
-(void)footerRefresh
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.myTableView  reloadData];
        [self.myTableView  footerEndRefreshing];
    });
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
