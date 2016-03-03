//
//  ComDayViewController.m
//  Lovers
//
//  Created by student on 15/12/28.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "ComDayViewController.h"
#import "FSCalendar.h"
#import "ComDayModel.h"
#import "CDTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "UIView+Toast.h"
#import "EditeViewController.h"

@interface ComDayViewController ()<FSCalendarDataSource,FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ComDayModelDelegate>
{
    FSCalendar *calendar;
    NSString *blName;
}
- (IBAction)SaveCD:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *CDtextField;
- (IBAction)CancleCDAction:(id)sender;

- (IBAction)AddComDayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *DateTextField;
@property (weak, nonatomic) IBOutlet UIView *AddView;
@property(nonatomic,strong)NSString *DateStr;
@property (weak, nonatomic) IBOutlet UIButton *Canclebutton;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;


@end

@implementation ComDayViewController

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=dataArray;
    [self.myTableView reloadData];
}
- (void)viewDidLoad {
    
    //定义坐上角添加纪念日按钮
    UIImage *image0 = [UIImage imageNamed:@"添加心情"];
      UIButton *buttonOther=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [buttonOther setImage:image0 forState:UIControlStateNormal];
    [buttonOther addTarget:self action:@selector(AddComDayAction:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *buOther=[[UIBarButtonItem alloc]initWithCustomView:buttonOther];
    self.navigationItem.rightBarButtonItem=buOther;
    
    
    //定义titleview
    UIView *titileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [label1 setText:@"纪念日"];
    label1.textColor=[UIColor whiteColor];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:18]];
    [titileView addSubview:label1];
    self.navigationItem.titleView = titileView;
    
    
   //设置navigationBar背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Snip20151228_1"] forBarMetrics:UIBarMetricsDefault];

    //设置添加界面背景色
    [self.AddView setBackgroundColor:[UIColor colorWithRed:233 green:213 blue:184 alpha:1]];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:233/255.0 green:231/255.0 blue:284/255.0 alpha:1.0]];
    
    //定义添加内容按钮
    UIButton *Contextbutton=[[UIButton alloc]init];
    [Contextbutton setBackgroundImage:[UIImage imageNamed:@"Addphoto"] forState:UIControlStateNormal];
    [Contextbutton  addTarget:self action:@selector(InputComDayContext) forControlEvents:UIControlEventTouchDown];
    [Contextbutton setFrame:CGRectMake(0, 0, 20, 20)];
    self.CDtextField.leftViewMode=UITextFieldViewModeAlways;
    self.CDtextField.leftView=Contextbutton;
    
    //添加日期按钮
    UIButton *DateButton=[[UIButton alloc]init];
    [DateButton setBackgroundImage:[UIImage imageNamed:@"Addphoto"] forState:UIControlStateNormal];
    [DateButton  addTarget:self action:@selector(InputComDayDate) forControlEvents:UIControlEventTouchDown];
    [DateButton setFrame:CGRectMake(0, 0, 20, 20)];
    self.DateTextField.leftViewMode=UITextFieldViewModeAlways;
    self.DateTextField.leftView=DateButton;
    [self.AddView setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self.AddView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:216/255.0 blue:165/255.0 alpha:1.0]];
    
    //定义挂历
    //需要的协议FSCalendarDataSource,FSCalendarDelegate
    CGFloat calender_y=CGRectGetMaxY(self.Canclebutton.frame)+10;
    calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, calender_y, winWidth   , winHeight * 0.32)];
    
    calendar.dataSource = self;
    calendar.delegate = self;
    [calendar setBackgroundColor:[UIColor clearColor]];
    [calendar.appearance setWeekdayFont:[UIFont systemFontOfSize:25]];
    [calendar.appearance setEventColor:[UIColor greenColor]]; // event mark color
    [calendar.appearance setSelectionColor:[UIColor orangeColor]]; // selection fill color
    [calendar.appearance setHeaderTitleFont:[UIFont systemFontOfSize:32]];
    [calendar.appearance setHeaderTitleColor:[UIColor blackColor]];
    [calendar.appearance setHeaderDateFormat:@"yyyy-MM"]; // header date format
    [calendar.appearance setTodayColor:[UIColor redColor]]; // today fill color
    calendar.alpha=0;
    [self.AddView addSubview:calendar];
    
    [self.SaveButton.layer setCornerRadius:5.0];
    [self.Canclebutton.layer setCornerRadius:5.0];
    
    
    self.myTableView.tableFooterView=[[UIView alloc]init];
    
    [super viewDidLoad];
    
    
    
    self.myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, winWidth, 30)];
    
    //获取数据
    [self getCDdate];
   
    // Do any additional setup after loading the view.
}//获取数据
-(void)getCDdate
{
    //得到数据
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    blName=[df objectForKey:@"belongName"];
    ComDayModel *model=[[ComDayModel alloc]init];
    [model loadCDModelDate:blName];
    model.returnBlock=^(id result)
    {
        
        self.dataArray=result;
        [df setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count] forKey:@"CDNumber"];
    };
}
-(void)InputComDayContext
{
    
}
-(void)InputComDayDate
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        calendar.alpha=1.0;
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击日期后
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date;
{
    [UIView animateWithDuration:0.5 animations:^{
        calendar.alpha=0;
    }];

    NSDateFormatter *fm=[[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd"];
    self.DateStr=[fm stringFromDate:date];
    self.DateTextField.text=self.DateStr;
}


#pragma mark TableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if (self.dataArray.count==0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //若新用户没有数据 则初始化一个提示  若有则显示
    if (self.dataArray.count==0) {
        static NSString *str=@"BlackCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.textLabel.text=@"您还没有纪念日，赶快添加属于你们的纪念日吧";
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            cell.textLabel.textColor=[UIColor lightGrayColor];
        }
        return cell;
    }else{
    
    static NSString *str=@"CDcell";
    CDTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"CDTableViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"35e474bbe77fa5ba8d7e2a3bdb1bfeec"] ]];
        ComDayModel *model=self.dataArray[indexPath.section];
        NSLog(@"%ld",(long)indexPath.section);
        model.index=indexPath;
        NSArray *temparray = [model.Date componentsSeparatedByString:@"-"];
        cell.DayLabel.text=temparray.lastObject;
        cell.Year_monthLabel.text=[NSString stringWithFormat:@"%@-%@",temparray[0],temparray[1]];
        cell.ContextLabel.text=model.Context;
        //[cell.ImageView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:180/255.0 blue:65/255.0 alpha:1.0]];
        [cell.ImageView setBackgroundColor: [UIColor colorWithRed:135/255.0 green:33/255.0 blue:32/255.0 alpha:1.0]];
        NSString *numberdate= [self intervalSinceNow:model.Date];
        cell.DayNumberLabel.text=numberdate;
        model.Daynumber=numberdate;
        cell.DayNumberLabel.textColor=[UIColor colorWithRed:27/255.0 green:151/255.0 blue:238/255.0 alpha:1.0];
    }
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.dataArray.count-1) {
        return 0.000000001;
    }else{
    return 10;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.navigationController);
    
    [self performSegueWithIdentifier:@"getCD" sender:self.dataArray[indexPath.section]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@",sender);
    if ([segue.destinationViewController isKindOfClass:[EditeViewController class]]) {
        EditeViewController *EdVC=(EditeViewController *)segue.destinationViewController;
        NSLog(@"%@",EdVC);
        EdVC.delegate=self;
        EdVC.model=sender;
    }
}


//判断天数方法
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSString *timeString=@"";
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:theDate];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.DateTextField) {
        return NO;
    }else{
    
    return YES;
    }

}

- (IBAction)CancleCDAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.AddView.alpha=0;
        
    }];
}

- (IBAction)AddComDayAction:(id)sender {

    [UIView animateWithDuration:0.5 animations:^{
        self.AddView.alpha=1.0;
        
    }];
    [self.AddView setFrame:CGRectMake(0, 0, winWidth, winHeight)];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)SaveCD:(id)sender {
    
    if (self.CDtextField.text==nil) {
        [self.view makeToast:@"内容不能为空" duration:2 position:@"CSToastPositionCenter"];
    }else if(self.DateTextField==nil){
     [self.view makeToast:@"日期不能为空" duration:2 position:@"CSToastPositionCenter"];
    }else{
    
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.AddView.alpha=0;
    }];
    
    BmobObject *UserOBJ = [BmobObject objectWithClassName:@"CommenDay"];
    [UserOBJ setObject:self.CDtextField.text forKey:@"context"];
    [UserOBJ setObject:self.DateTextField.text forKey:@"Date"];
    [UserOBJ setObject:blName forKey:@"owner"];
    
    [UserOBJ saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {

        [self getCDdate];
        
            [self.myTableView reloadData];
        

    }];
    
    }
    
}
-(void)CancleCDData:(NSIndexPath *)index;
{
    NSLog(@"%ld",(long)index.section);
    ComDayModel *Model=self.dataArray[index.section];
    [self.dataArray removeObjectAtIndex:index.section];
    [self.myTableView reloadData];
    NSLog(@"%li",(long)index.row);
    NSLog(@"%@",Model.objectId);
    //删除Timers表中的说说数据
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"CommenDay"];
    [bquery getObjectInBackgroundWithId:Model.objectId block:^(BmobObject *object, NSError *error) {
        
        NSLog(@"%@",object);
        NSLog(@"%@",error);
        [object deleteInBackground];
        [self cancleImage:Model];
        
        [self getCDdate];
        
        // 刷新数据
        [self.myTableView reloadData];
    }];
    //删除Image表中本条说说关联的图片数据
  
    
}
-(void)cancleImage:(ComDayModel *)Model
{
    BmobQuery   *Imagebquery = [BmobQuery queryWithClassName:@"CommenDay"];
    [Imagebquery whereKey:@"owner" equalTo:Model.objectId];
    [Imagebquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            [obj deleteInBackground];
            NSLog(@"已经删除照片");
        }
        
    }];
}
@end
