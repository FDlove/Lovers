//
//  PersonalInfoViewController.m
//  Lovers
//
//  Created by student on 16/1/11.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "TimeViewController.h"
#import "PersonalModel.h"
#import "PersonalImageModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PhotoWallViewController.h"
@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate,PhotoWallViewControllerDelegate>
{
    UIView *line;
     UIScrollView *myscrollView;
    NSTimer *timer;
    BOOL changedYes;
    NSMutableArray *ImagedataArray;
    NSInteger Row;
    //记录是点击了哪条cell
    MBProgressHUD *hub;
    NSMutableArray *SexArray;
}
@property (weak, nonatomic) IBOutlet UIView *SexView;
@property (weak, nonatomic) IBOutlet UIPickerView *SexPickerView;
- (IBAction)DoneSexPicker:(id)sender;
- (IBAction)CancleSexPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *BirthDateView;
@property (weak, nonatomic) IBOutlet UIDatePicker *BirthDatePicker;
- (IBAction)CancleBirthDate:(id)sender;
- (IBAction)DoneBirthDate:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)PersonalModel *personalModel;
@property(nonatomic,strong)NSString *belongName;

@end

@implementation PersonalInfoViewController


-(void)setPersonalModel:(PersonalModel *)personalModel
{
    _personalModel=personalModel;
    [self.myTableView  reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    
     timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scollchangeImage) userInfo:nil repeats:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    line =[[UIView alloc]initWithFrame:CGRectMake(0, 100, 0, 2)];
    [line setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:line];
    
    hub=[[MBProgressHUD alloc]initWithView:self.view];
    hub.delegate=self;
    hub.labelText=@"正在保存！请稍后...";
    [self.view addSubview:hub];
    //获取查询时所需要的字段
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.belongName=[defaults objectForKey:@"belongName"];
    //查找blname数据 若没有先创建一条数据插入
    //查找有没有blName的信息 若没有创建数据插入 若有查找数据修改
    BmobQuery *query=[BmobQuery queryWithClassName:@"PersonalInfo"];
    
    [query whereKey:@"owner" equalTo:self.belongName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0)//没有创建过个人信息数据
        {
            //创建数据插入
           
            //在PersonalInfo创建一条数据，如果当前没PersonalInfo表，则会创建PersonalInfo表
            BmobObject  *OBJ = [BmobObject objectWithClassName:@"PersonalInfo"];
            
            [OBJ setObject:self.belongName forKey:@"owner"];
            
            [OBJ setObject:@"" forKey:@"Name"];
 
            [OBJ setObject:[NSDate date] forKey:@"birthDate"];
            
            [OBJ setObject:@""  forKey:@"schoolName"];
            
            [OBJ setObject:@""  forKey:@"Sex"];
            
            [OBJ setObject:@""  forKey:@"Lovers"];
            //异步保存到服务器
            [OBJ saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //创建成功后会返回objectId，updatedAt，createdAt等信息
                    //创建对象成功，打印对象值
                    NSLog(@"%@",OBJ);
                } else if (error){
                    //发生错误后的动作
                    NSLog(@"%@",error);
                } else {
                    NSLog(@"Unknow error");
                }
            }];
        }else{
            NSLog(@"已经有数据");
        }
    }];
   //若有个人信息  则回调获取个人信息表中属于用户的信息表
    PersonalModel *personalModel=[[PersonalModel alloc]init];
    [personalModel loadStatusData:self.belongName];
    personalModel.returnBlock=^(id result)
        {
            self.personalModel=result;
            [self addScrollView];
        };
    
    //若没有个人信息则
     [self initialScrollView];

    //设置时光界面的背景图片
    [self.backgroundImageView setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:236/255.0 alpha:1.0]];
    //设置Cell背景透明
    self.myTableView.backgroundColor = [UIColor clearColor];
    //去除空白cell单元格
    //self.myTableView.tableFooterView=[[UIView alloc]init];
    //去除cell间隔线
    self.myTableView.separatorStyle=UITableViewCellSelectionStyleNone;

#pragma mark 设置当前时间 默认当前时间
    //nsstring->nsdate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd "];
    NSDate *myDate = [formatter dateFromString:@"2015-10-30 "];
    [self.BirthDatePicker setDate:myDate];
    
    
#pragma mark minDate maxDate
    NSDate *minDate = [formatter dateFromString:@"1970-10-01"];
    NSDate *maxDate = [NSDate date];
    self.BirthDatePicker.maximumDate = maxDate;
    self.BirthDatePicker.minimumDate = minDate;
    
#pragma mark mode属性
    [self.BirthDatePicker setDatePickerMode:UIDatePickerModeDate];
    
    //设置SexPickerView
     [self pickerView:self.SexPickerView didSelectRow:0 inComponent:0];
     [self.SexPickerView setBackgroundColor:[UIColor lightGrayColor]];
    
    
 //   [self.view bringSubviewToFront:self.BirthDateView];
    [self.view bringSubviewToFront:self.SexPickerView];
    //定义退出按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancleView) forControlEvents:UIControlEventTouchDown];
    backButton.layer.cornerRadius = CGRectGetHeight(backButton.bounds) / 2;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=bu;
    
}
-(void)cancleView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initialScrollView
{
    myscrollView=[[UIScrollView alloc]init];
    [myscrollView setFrame:CGRectMake(0, 0, winWidth, 300)];
    [myscrollView setBackgroundColor:[UIColor lightGrayColor]];
    myscrollView.pagingEnabled = YES;
    [myscrollView setBackgroundColor:[UIColor whiteColor]];
    self.myTableView.tableHeaderView=myscrollView;
    
}

-(void)addScrollView
{
      myscrollView =[[UIScrollView alloc]init];
        for (int i =0; i<self.personalModel.imageArray.count; i++) {
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*winWidth, 0, winWidth, 300)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:self.personalModel.imageArray[i]]];
            [myscrollView addSubview:imageview];
        }
        [myscrollView setContentSize:CGSizeMake(winWidth*self.personalModel.imageArray.count, 300)];
    
       [myscrollView setFrame:CGRectMake(0, 0, winWidth, 300)];
        myscrollView.pagingEnabled = YES;
     [myscrollView setBackgroundColor:[UIColor whiteColor]];
        self.myTableView.tableHeaderView=myscrollView;
    

        myscrollView.delegate=self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 5;
    }else{
        return 1;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mypersonalcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            cell.textLabel.text =@"照片墙";
            
        }else if (indexPath.row==1) {
            cell.textLabel.text=@"昵称：";
            cell.detailTextLabel.text=self.personalModel.Name;
        }else if(indexPath.row==2)
        {
            cell.textLabel.text=@"出生日期：";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:self.personalModel.birthDate];
            
            //cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.personalModel.birthDate];
            cell.detailTextLabel.text=currentDateStr;
        
        }else if(indexPath.row==3){
            cell.textLabel.text=@"毕业院校：";
            cell.detailTextLabel.text=self.personalModel.schoolName;
        }else {
                       cell.textLabel.text=@"性别：";
            cell.detailTextLabel.text=self.personalModel.sex;
        }
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"locationIcon"]];

        cell.textLabel.text=@"Lovers";
        cell.detailTextLabel.text=self.personalModel.Lovers;
    }
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
//点击弹出Alert按钮后执行的方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *txt = [alertView textFieldAtIndex:0];
    if (buttonIndex==1)//确定
    {
        
        //判断是那条Cell
        //更新数据
        if(Row==1)
        {
            NSLog(@"改变昵称");
            //查找有没有blName的信息 若没有创建数据插入 若有查找数据修改
            BmobQuery *query=[BmobQuery queryWithClassName:@"PersonalInfo"];
            
            [query whereKey:@"owner" equalTo:self.belongName];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count==0)//没有创建过个人信息数据
                {
                    //创建数据插入
                    //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
                    
                }else{
                    //直接修改数据
                    for (BmobObject *obj in array) {
                        [obj setObject:txt.text forKey:@"Name"];
                        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                                NSLog(@"%@",[obj objectForKey:@"Name"]);
                                self.personalModel.Name=[obj objectForKey:@"Name"];
                                [self.myTableView reloadData];
                            } else {
                                NSLog(@"%@",error);
                            }
                        }];
                    }
                }
            }];
        }else //if(Row==3)
        {
            NSLog(@"改变院校");
            
            //查找有没有blName的信息 若没有创建数据插入 若有查找数据修改
            BmobQuery *query=[BmobQuery queryWithClassName:@"PersonalInfo"];
            
            [query whereKey:@"owner" equalTo:self.belongName];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count==0)//没有创建过个人信息数据
                {
                    //创建数据插入
                }else{
                    //直接修改数据
                    for (BmobObject *obj in array) {
                        [obj setObject:txt.text forKey:@"schoolName"];
                        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                                NSLog(@"%@",[obj objectForKey:@"schoolName"]);
                                self.personalModel.schoolName=[obj objectForKey:@"schoolName"];
                                [self.myTableView reloadData];
                            } else {
                                NSLog(@"%@",error);
                            }
                        }];
                    }
                }
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section=indexPath.section;
    Row=indexPath.row;
    if (section==0) {
        if (Row==0) {
            //更改照片墙
            //把用户的照片墙数组传过去
            [self performSegueWithIdentifier:@"PhotoWall" sender:self.personalModel.imageArray];
            
            [timer invalidate];
        }else if(Row==1){
            
            //更改昵称
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
            [alertView show];
            
        }else if(Row==2){
            
        //更改出生日期
            [UIView animateWithDuration:0.5 animations:^{
                [self.BirthDateView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.BirthDateView.frame.size.height-44, winWidth   , 300)];
//                [self.BirthDatePicker setBounds:CGRectMake(0, 30, winWidth, 270)];
            
            }];

            
        }else if(Row==3){
            
            //更改毕业院校
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"毕业院校" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
            [alertView show];
            
        }else{
        //更改性别
            [UIView animateWithDuration:0.5 animations:^{
                [self.SexView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.SexView.frame.size.height-60, winWidth, 150)];

                          }];
            
        }
    }else{
        //更改绑定Lovers
        
    [self performSegueWithIdentifier:@"changeLovers" sender:nil];
       
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PhotoWallViewController class]]) {
        PhotoWallViewController *PWVC=(PhotoWallViewController *)segue.destinationViewController;
        PWVC.ImageArray=[NSMutableArray array];
        PWVC.ImageArray=[self.personalModel.imageArray mutableCopy];
        PWVC.delegate=self;
    }

}
//从照片墙转换回来后执行上传照片任务（用新数组刷新ScrollView  执行删除任务，删除原照片墙所有照片 更新新照片数组 ）
-(void)UpImageWallData:(NSMutableArray *)ImageArray
{
    //刷新ScrollView
    [self updateScrollView:ImageArray];
    //在数据表中删除所有数据
    BmobQuery *query =[BmobQuery queryWithClassName:@"personalInfoImage"];
    [query whereKey:@"owner" equalTo:self.personalModel.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        //删除旧数据
        for (BmobObject *obj in array) {
            [obj deleteInBackground];
        }
        //删除成功之后更新新图片
            //上传新数组中的照片
            for (int i=0; i<ImageArray.count ; i++) {
                if ([ImageArray[i] isKindOfClass:[UIImage class]]) {
                    
                    BmobObject *imageOBJ = [BmobObject objectWithClassName:@"personalInfoImage"];
                    NSData *date=UIImageJPEGRepresentation(ImageArray[i], 1.0);
                    BmobFile *file=[[BmobFile alloc] initWithFileName:@"121.png" withFileData:date];
                    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                       
                    if (isSuccessful) {
                        NSLog(@"上传成功");
                        [imageOBJ setObject:file forKey:@"image"];
                        [imageOBJ setObject:self.personalModel.objectId forKey:@"owner"];
                        [imageOBJ saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"存储成功");
                            }else{
                                NSLog(@"%@",error);
                            }
                        }];
                    }
                        
                        
                    } withProgressBlock:^(float progress) {
                        NSLog(@"%.2f",progress);

                        CGFloat width1=winWidth*progress;
                        [line setFrame:CGRectMake(0, 2, width1, 3)];
                       //[line setBounds:CGRectMake(0, 20, width1, 3)];
                       //[line setBackgroundColor:[UIColor redColor]];
                        if (progress==1) {
                            [line setBackgroundColor:[UIColor clearColor]];
                        }
                        
                    }];
   
                }else{
                                    }
                
            }
        
    }];
    
}


-(void)updateScrollView:(NSMutableArray *)array
{
    self.personalModel.imageArray =[array mutableCopy];
    [myscrollView setContentSize:CGSizeMake(winWidth*self.personalModel.imageArray.count, 300)];

    for (id tempView in myscrollView.subviews) {
        [tempView removeFromSuperview];
    }
    
    
    for (int i =0; i<array.count; i++) {
        if ([array[i] isKindOfClass:[UIImage class]]) {
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*winWidth, 0, winWidth, 300)];
            [imageview setImage:array[i]];
            [myscrollView addSubview:imageview];
        }else{
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*winWidth, 0, winWidth, 300)];
        [imageview sd_setImageWithURL:[NSURL URLWithString: self.personalModel.imageArray[i]]];
        [myscrollView addSubview:imageview];
        }
    }
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


-(void)scollchangeImage
{
    if (self.personalModel.imageArray==nil||self.personalModel.imageArray.count==1) {
        [timer invalidate];
    }else{
    if (myscrollView.contentOffset.x==winWidth*(self.personalModel.imageArray.count-1)) {
        changedYes=NO;
    }
    if (myscrollView.contentOffset.x==0) {
        changedYes=YES;
    }
    if (changedYes) {
        [UIView animateWithDuration:1 animations:^{
            myscrollView.contentOffset = CGPointMake(myscrollView.contentOffset.x+winWidth, 0);
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            myscrollView.contentOffset = CGPointMake(myscrollView.contentOffset.x-winWidth,0);
        }];
    }
    }
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



//点击cancle隐藏DatePicker
- (IBAction)CancleBirthDate:(id)sender {
    [self hidepickerView];
}

- (IBAction)DoneBirthDate:(id)sender {
    [hub show:YES];
    //保存并且修改数据
    
    NSLog(@"改变出生日期");
    //查找有没有blName的信息 若没有创建数据插入 若有查找数据修改
    BmobQuery *query=[BmobQuery queryWithClassName:@"PersonalInfo"];
    
    [query whereKey:@"owner" equalTo:self.belongName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0)//没有创建过个人信息数据
        {
            //创建数据插入
            //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
            
        }else{
            //直接修改数据
            for (BmobObject *obj in array) {
                [obj setObject:self.BirthDatePicker.date forKey:@"birthDate"];
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    [hub hide:YES];
                    if (isSuccessful) {
                        
                        NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                        NSLog(@"%@",[obj objectForKey:@"Name"]);
                        self.personalModel.birthDate=[obj objectForKey:@"birthDate"];
                        [self.myTableView reloadData];
                        [self hidepickerView];
                    } else {
                        NSLog(@"%@",error);
                    }
                }];
            }
        }
    }];
    
}
//隐藏DatePicker
- (void)hidepickerView{
    [UIView animateWithDuration:0.5 animations:^{
        [self.BirthDateView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.BirthDateView.frame.size.width, self.BirthDateView.frame.size.height)];
        
    }];
    
}
- (void)hideSexpickerView{
    [UIView animateWithDuration:0.5 animations:^{
        [self.SexView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.SexView.frame.size.width, self.SexView.frame.size.height)];
        
    }];
    
}
#pragma mark UIpickerViewDatasource
// returns the number of 'columns' to display.
//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
//返回每一列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark UIPickerViewDelegate
//每一列每一行显示什么内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0) {
        return [NSString stringWithFormat:@"女"];
    }else{
    return [NSString stringWithFormat:@"男"];
    }
}

//修改row的高度跟宽度
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 80;
}

//选中某一行触发的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    //    [pickerView selectedRowInComponent:0]//返回某一列当前选中的行
    
}
//点击更新用户性别
- (IBAction)DoneSexPicker:(id)sender {
    //存数据
    [hub show:YES];
    //保存并且修改数据
    
    NSLog(@"改变性别");
    //查找有没有blName的信息 若没有创建数据插入 若有查找数据修改
    BmobQuery *query=[BmobQuery queryWithClassName:@"PersonalInfo"];
    
    [query whereKey:@"owner" equalTo:self.belongName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0)//没有创建过个人信息数据
        {
        }else{
            //直接修改数据
            for (BmobObject *obj in array) {
                NSInteger currentRow = [self.SexPickerView selectedRowInComponent:0];
                NSString *str=[[NSString alloc]init];
                if (currentRow==0) {
                    str =@"女";
                }else{
                    str=@"男";
                }
                [obj setObject:str forKey:@"Sex"];
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    [hub hide:YES];
                    if (isSuccessful) {
                        
                        NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                        NSLog(@"%@",[obj objectForKey:@"Sex"]);
                        self.personalModel.sex=[obj objectForKey:@"Sex"];
                        [self.myTableView reloadData];
                         [self hideSexpickerView];
                    } else {
                        NSLog(@"%@",error);
                    }
                }];
            }
        }
    }];
}
//点击隐藏SexPickerView
- (IBAction)CancleSexPicker:(id)sender {
    [self hideSexpickerView];
}
@end
