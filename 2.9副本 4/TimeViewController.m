//
//  TimeViewController.m
//  Lovers
//
//  Created by student on 15/12/28.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StatusCell.h"
#import "StatusModel.h"
#import <BmobSDK/Bmob.h>
#import "AddFeelViewController.h"
#import "MJRefresh.h"
#import "PersonalInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "UIView+Toast.h"
@interface TimeViewController ()<UITableViewDataSource,UITableViewDelegate,StatusCellDelegate,updatedelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    
    MBProgressHUD *hub;
    UIButton *headerButton;//头像
    
    NSMutableArray *Image;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property(nonatomic,strong)NSString *username;

@property(nonatomic,strong)NSString *loverName;

@property(nonatomic,strong)NSString *blName;

@property(nonatomic,strong)NSString *newblName;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic,strong)NSDate *CreatDate;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation TimeViewController
static NSString *identifier = @"mycell";
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=dataArray;
    [self.mytableView  reloadData];
}
-(void)getDataArray
{
    //获取查询时所需要的字段
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.username=[defaults objectForKey:@"username"];
    NSLog(@"%@",self.username);
    //  [self getLoverName];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Users"];
    [bquery  whereKey:@"UserName" equalTo:self.username];
    [bquery  findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            NSLog(@"用户不存在");
        }else
        {
            for(BmobObject *objc in array)
            {
                
                 NSDate *date=  [objc objectForKey:@"createAt"];
                 self.CreatDate=date;
                
                
                self.loverName=[objc objectForKey:@"myLovers"];
                NSUserDefaults *defaultLover=[NSUserDefaults standardUserDefaults];
                
                [defaultLover setObject:self.loverName forKey:@"loversName"];
                
                self.blName=[NSString stringWithFormat:@"%@+%@",self.username,self.loverName];
                //刷新头像
                 [self setHeaderButtonImage];
                //得到自己发布的字段标记就存入单例
                NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
                
                [de setObject:self.blName forKey:@"belongName"];
                self.newblName=[NSString stringWithFormat:@"%@+%@",self.loverName,self.username];
                
                if (self.blName==nil) {
                    NSLog(@"111");
                }else{
                    [self getTimersDate];
                }
            }
        }
    }];
}

-(void)getTimersDate
{
    StatusModel *statuModel=[[StatusModel alloc]init];
    [statuModel loadStatusData:self.blName];
    //获取说说数组
    statuModel.returnBlock=^(id result)
    {
        self.dataArray=result;
        [self.mytableView reloadData];
        NSUserDefaults *df11=[NSUserDefaults standardUserDefaults];
        
        [df11 setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count] forKey:@"TimersNumber"];
    };
}
//判断天数方法
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSString *timeString=@"";
    
    NSString *str=[theDate substringToIndex:10];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:str];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    
    NSInteger iDays = lTime/60/60/24;
    timeString=[NSString stringWithFormat:@"%ld",(long)iDays];
    return timeString;
}


- (void)viewDidLoad {

    
    [self getDataArray];
    [self  setUprefresh];
    
    hub=[[MBProgressHUD alloc]initWithView:self.view];
    hub.delegate=self;
    hub.labelText=@"正在保存！请稍后...";
    [self.view addSubview:hub];
    //设置时光界面的背景图片
    [self.backgroundImageView setImage:[UIImage imageNamed:@"back02"]];
    //设置Cell背景透明
    self.mytableView.backgroundColor = [UIColor clearColor];
    //去除空白cell单元格
    self.mytableView.tableFooterView=[[UIView alloc]init];
    //去除cell间隔线
    self.mytableView.separatorStyle=UITableViewCellSelectionStyleNone;
       //定义背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Snip20151228_1"] forBarMetrics:UIBarMetricsDefault];
    //定义菜单按钮
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changed) forControlEvents:UIControlEventTouchDown];
    button.layer.cornerRadius = CGRectGetHeight(button.bounds) / 2;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=bu;
    
    //定义添加动态按钮
    UIButton *buttonOther=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [buttonOther setImage:[UIImage imageNamed:@"添加心情"] forState:UIControlStateNormal];
    [buttonOther addTarget:self action:@selector(ADDFeel) forControlEvents:UIControlEventTouchDown];
    
   // buttonOther.layer.borderWidth=2;
    //buttonOther.layer.borderColor=[UIColor whiteColor].CGColor;
    buttonOther.layer.cornerRadius = CGRectGetHeight(buttonOther.bounds) / 2;
   // buttonOther.clipsToBounds = YES;
    UIBarButtonItem *buOther=[[UIBarButtonItem alloc]initWithCustomView:buttonOther];
    self.navigationItem.rightBarButtonItem=buOther;
    
    //定义title
    UIView *titileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [label1 setText:@"Lover时光"];
    label1.textColor=[UIColor whiteColor];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:18]];
    [titileView addSubview:label1];
    self.navigationItem.titleView = titileView;

    //创建headerView
    UIImageView *imageView=[[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(0, 0, winWidth, 200)];
    [imageView setImage:[UIImage imageNamed:@"HeadViewBack"]];
    [imageView setUserInteractionEnabled:YES];
    //创建头像
    headerButton=[[UIButton alloc]initWithFrame:CGRectMake(winWidth/2-40, 200/2-40, 80, 80)];
    //给头像button设置图片
    [headerButton addTarget:self action:@selector(updateHeaderButtonImage) forControlEvents:UIControlEventTouchDown];
    headerButton.layer.borderWidth=2;
    headerButton.layer.borderColor=[UIColor whiteColor].CGColor;
    headerButton.layer.cornerRadius = CGRectGetHeight(headerButton.bounds) / 2;
    headerButton.clipsToBounds = YES;
    [imageView addSubview:headerButton];
    
    //定义记录在一起天数
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, 120, 20)];
    label.text =@"我们的Love";
    label.textColor=[UIColor whiteColor];
    [label setFont:[UIFont systemFontOfSize:10]];
    [imageView addSubview:label];
    
    
     CGFloat lab_y=CGRectGetMaxY(label.frame);
    UILabel *lab=[[UILabel alloc]init];
    CGSize lab_size = [lab.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]} context:nil].size;
    [lab setFrame:CGRectMake(0, lab_y, lab_size.width, lab_size.height)];
    lab.textColor=[UIColor whiteColor];
    [lab setFont:[UIFont systemFontOfSize:40]];
    [imageView addSubview:lab];
    
    CGFloat label1_x=CGRectGetMaxX(lab.frame);
    CGFloat label1_y=CGRectGetMaxY(lab.frame);
    UILabel *labell=[[UILabel alloc]initWithFrame:CGRectMake(label1_x, label1_y-20, 20, 20)];
    labell.textColor=[UIColor whiteColor];
    [labell setFont:[UIFont systemFontOfSize:10]];
    labell.text=@"天";
    [imageView addSubview:labell];
    
    //查询创建天数并显示
    BmobQuery *query=[[BmobQuery alloc]initWithClassName:@"Users"];
    [query whereKey:@"UserName" equalTo:self.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        if (array.count==0) {
            
        }else{
            
            for (BmobObject *obj in array) {
                
               
               
                NSString *updatedDate=[NSString stringWithFormat:@"%@",[obj objectForKey:@"updatedAt"]];
   
                
                NSString *str= [self intervalSinceNow:updatedDate];
                int datenumber=[str intValue];
                lab.text=[NSString stringWithFormat:@"%d",datenumber+1];
                
                CGFloat lab_y=CGRectGetMaxY(label.frame);
                CGSize lab_size = [lab.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]} context:nil].size;
                [lab setFrame:CGRectMake(0, lab_y, lab_size.width, lab_size.height)];

                CGFloat label1_x=CGRectGetMaxX(lab.frame);
                CGFloat label1_y=CGRectGetMaxY(lab.frame);
               [labell setFrame: CGRectMake(label1_x, label1_y-20, 20, 20)];
                
            }
            
            
        }
    }];
    

    self.mytableView.tableHeaderView=imageView;
  
  
    
    NSLog(@"-----home-----%@",self.navigationController);
    [super viewDidLoad];
       // Do any additional setup after loading the view.
    NSLog(@"%@",self.dataArray);
    
     [self  setUprefresh];
}

-(void)ADDFeel
{
    NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
    
    [de setObject:self.blName forKey:@"belongName"];
    [self performSegueWithIdentifier:@"addFeel" sender:nil];
}

//初始化图片（得到self.blName后再刷新）
-(void)setHeaderButtonImage
{
//先查PersonalInfo表 如果没有数据 则创建初始化头像  如果有数据但是[obj objectforkey:@"headImage"]为空则创建初始化头像 若有数据且[obj objectforkey:@"headImage"]有图片 则设置图片
    BmobQuery *query=[BmobQuery queryWithClassName:@"Users"];
    
    [query whereKey:@"UserName" equalTo:self.username];
   
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            [headerButton setBackgroundImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
        }else{
        
            for (BmobObject *obj in array) {
                BmobFile *file=[obj objectForKey:@"headimage"];
                if (file.url) {

                    [headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:file.url] forState:UIControlStateNormal];

                    [self headerRefresh];
                }else{
                [headerButton setBackgroundImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
                }
            }
        }
        
    }];
    
}
-(void)updateHeaderButtonImage
{
    //点击之后调用相机
    __block NSUInteger sourceType=0;
    //弹出选择图片来源提示框
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        //调用相册或相机
        [self chooseImage:sourceType];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sourceType=UIImagePickerControllerSourceTypeCamera;
        //调用相册或相机
        [self chooseImage:sourceType];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}
-(void)chooseImage:(NSUInteger )sourceType
{
    //创建UIImagePickerController对象
    UIImagePickerController *imagepickerController=[[UIImagePickerController alloc]init];
    //设置代理
    imagepickerController.delegate=self;
    //是否允许编辑
    imagepickerController.allowsEditing=YES;
    //图片来源
    imagepickerController.sourceType=sourceType;
    [self presentViewController:imagepickerController animated:nil completion:nil];

}
//在相册中选择图片点击choose触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    
    
    //立即更新图片
        [headerButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [hub show:YES];
    //更新数据
    BmobQuery *query=[BmobQuery queryWithClassName:@"Users"];
       [query whereKey:@"UserName" equalTo:self.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count==0) {
                NSLog(@"无数据");
                //创建一条空数据
            }else{
            //修改数据
                for (BmobObject *obj in array)
                {
                
                    NSData *date=UIImageJPEGRepresentation(image, 1.0);
                    BmobFile *file1 = [[BmobFile alloc] initWithFileName:@"121.png" withFileData:date];
                    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
                        //如果文件保存成功，则把文件添加到filetype列
                        if (isSuccessful) {
                
                            [obj setObject:file1  forKey:@"headimage"];
                            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                                    [hub hide:YES];
                                    
                                } else {
                                    NSLog(@"%@",error);
                                }
                            }];
                            [obj saveInBackground];
                            
                        }else{
                            //进行处理
                        }
                    }];

                    
                 }
                }
        }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
        //初始化图片
    

}


//点击头像执行的方法
-(void)changed
{
   
    NSLog(@"你点及了菜单");
    [self showGrid];
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld: %@",itemIndex, item.title);
    
    if (itemIndex==0) {
        [self performSegueWithIdentifier:@"personal" sender:nil];
        //跳转到添加界面是保存belongName
        
        
    }
    if(itemIndex==1){
        NSUserDefaults *de=[NSUserDefaults standardUserDefaults];
        
        [de setObject:self.blName forKey:@"belongName"];
     [self performSegueWithIdentifier:@"addFeel" sender:nil];
    }
    if (itemIndex==2) {
         [self.view makeToast:@"但是并没有用" duration:2 position:@"CSToastPositionCenter"];
    }
    if (itemIndex==3) {
         [self performSegueWithIdentifier:@"Speak" sender:nil];
    }
    if (itemIndex==4) {
         [self performSegueWithIdentifier:@"AboutUs" sender:nil];
    }
      
    if(itemIndex==5)
    {
        
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:@"注销后需要重新登录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AppDelegate *app=[UIApplication sharedApplication].delegate;
            UIStoryboard *storybd=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *mainVC=[storybd instantiateViewControllerWithIdentifier:@"PrepareVC"];
            app.window.rootViewController=mainVC;
            
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        
        
    }
    

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[PersonalInfoViewController class]]) {
        NSLog(@"hahaha");
    }
    if ([segue.destinationViewController isKindOfClass:[AddFeelViewController class]]) {
        AddFeelViewController *add =(AddFeelViewController *)segue.destinationViewController;
        add.delegate=self;
    
    }
    
}

#pragma mark - Private

- (void)showImagesOnly {
    NSInteger numberOfOptions = 5;
    NSArray *images = @[
                        [UIImage imageNamed:@"arrow"],
                        [UIImage imageNamed:@"attachment"],
                        [UIImage imageNamed:@"block"],
                        [UIImage imageNamed:@"bluetooth"],
                        [UIImage imageNamed:@"cube"],
                        [UIImage imageNamed:@"download"],
                        [UIImage imageNamed:@"enter"],
                        [UIImage imageNamed:@"file"],
                        [UIImage imageNamed:@"github"]
                        ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 5;
    NSArray *options = @[
                         @"个人资料",
                         @"Attach",
                         @"Cancel",
                         @"Bluetooth",
                         @"Deliver",
                         @"Download",
                         @"Enter",
                         @"Source Code",
                         @"Github"
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 6;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"个人资料"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"心情"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"你可以点我"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"我有话说"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"关于我们"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"注销"],

                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    StatusCell *cell = [StatusCell statusCellWith:tableView withIdentifier:identifier];
        cell.status = self.dataArray[indexPath.row];
    cell.delegate=self;
    cell.index = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusModel *sModel=[self.dataArray objectAtIndex:indexPath.row];
    
    StatusCell *cell=[StatusCell statusCellWith:tableView withIdentifier:identifier];
    cell.status=sModel;
    return cell.height;
    
}

-(void)CancleData:(NSIndexPath *)index
{
    //点击删除是否删除提示窗
    UIAlertController*alert =[UIAlertController alertControllerWithTitle:@"是否删除本条记录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //删除数据
        [UIView animateWithDuration:0.7 delay:0 options:0 animations:^(){
            [self deleteData:index];
            
        } completion:^(BOOL finished)
         {
             
         }];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了cell");
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}
//执行删除操作
-(void)deleteData:(NSIndexPath *)index
{
    
    StatusModel *sModel=self.dataArray[index.row];
    [self.dataArray removeObjectAtIndex:index.row];
    NSLog(@"%li",(long)index.row);
    NSLog(@"%@",sModel.objectId);
    //删除Timers表中的说说数据
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Timers"];
    [bquery getObjectInBackgroundWithId:sModel.objectId block:^(BmobObject *object, NSError *error) {
        
        NSLog(@"%@",object);
        NSLog(@"%@",error);
       // [object deleteInBackground];
        [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            [self cancleImage:sModel];
        
            [self getTimersDate];
            // 刷新数据
            [self  setUprefresh];
        }];
        
    }];
    //删除Image表中本条说说关联的图片数据
    
}

-(void)cancleImage:(StatusModel *)sModel
{
    BmobQuery   *Imagebquery = [BmobQuery queryWithClassName:@"Image"];
    [Imagebquery whereKey:@"owner" equalTo:sModel.objectId];
    [Imagebquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            [obj deleteInBackground];
            NSLog(@"已经删除照片");
        }
        
    }];
}
#pragma mark-MJRefresh
-(void)setUprefresh
{
    
    
    [self.mytableView   addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    
    [self.mytableView   addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.mytableView  headerBeginRefreshing];
    
    
    [self.mytableView  setHeaderPullToRefreshText:@"下拉.."];
    [self.mytableView   setHeaderReleaseToRefreshText:@"请松手..."];
    [self.mytableView   setHeaderRefreshingText:@"正在刷新.."];
    
    [self.mytableView  setFooterPullToRefreshText:@"上拉.."];
    [self.mytableView   setFooterReleaseToRefreshText:@"请松手..."];
    [self.mytableView   setFooterRefreshingText:@"正在刷新.."];
    
}

-(void)headerRefresh
{
    [self getTimersDate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mytableView  reloadData];
        [self.mytableView  headerEndRefreshing];
    });
   
}

/**
 上拉加载更多
 */
-(void)footerRefresh
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.mytableView  reloadData];
        [self.mytableView  footerEndRefreshing];
    });
}
//添加界面转换回视图是的代理执行方法
-(void)upDate
{
    [self getTimersDate];
    [self  setUprefresh];
}
@end
