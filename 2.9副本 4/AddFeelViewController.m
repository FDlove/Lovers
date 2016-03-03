//
//  AddFeelViewController.m
//  Lovers
//
//  Created by student on 16/1/11.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "AddFeelViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+Toast.h"
#import "MBProgressHUD.h"

@interface AddFeelViewController ()<UITextViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>
{
    CLLocationManager *locationmanager;
    UIButton *addphotoButton;
    UITextField *LocationTextField;
    
    MBProgressHUD *hub;
    UILabel *wordlabel;
    UIImageView * View;
    BOOL same;
}
@property (weak, nonatomic) IBOutlet UITextView *FeelTextView;
@property(nonatomic,strong)NSString *belongName;


@end

@implementation AddFeelViewController


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
  
    if (range.location<=800)
    {
        NSNumber *aNumber = [NSNumber numberWithInteger:range.location];
        int a=(int )[aNumber intValue];
        int b=800;
        int c=b-a;
        [wordlabel setText:[NSString stringWithFormat:@"%i",c]];
        CGSize wordlabel_size = [wordlabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        CGFloat wordlel_x=CGRectGetMaxX(self.FeelTextView.frame)-wordlabel_size.width;
        CGFloat wordlel_y=CGRectGetMaxY(self.FeelTextView.frame)-20;
        [wordlabel setFrame:CGRectMake(wordlel_x, wordlel_y, wordlabel_size.width, 20)];
        return  YES;
    }
    else
    {
        return NO;
    }
   
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    same=NO;//查询发布内容是否相同  初始化不同
    self.imageArray =[NSMutableArray array];
    
    hub=[[MBProgressHUD alloc]initWithView:self.view];
    hub.delegate=self;
    hub.labelText=@"正在保存！请稍后...";
    [self.view addSubview:hub];
    
    
    //获取归属名
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.belongName=[defaults objectForKey:@"belongName"];

    //初始化放图片的UIView
    View=[[UIImageView alloc]init];
    
    CGFloat View_y=CGRectGetMaxY(self.FeelTextView.frame)+30;
    CGFloat View_x=0;
    CGFloat View_width=winWidth;
    CGFloat View_height=(winWidth-50)/4*3;
    [View setFrame:CGRectMake(View_x, View_y,View_width,View_height)];
    
    //[View setImage:[UIImage imageNamed:@"addohotobackground"]];
   // [View setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:View];
    
    //设置添加图片的点击按钮
    addphotoButton=[[UIButton alloc]init];
    [addphotoButton setImage:[UIImage imageNamed:@"Addphoto"] forState:UIControlStateNormal];
    
    
    //设置初始添加图片按钮位置
    CGFloat addphotoButton_y=CGRectGetMaxY(self.FeelTextView.frame)+44;
    CGFloat addphotoButton_width=40;
    CGFloat addphotoButton_x=winWidth-addphotoButton_width;
    CGFloat addphotoButton_height=28;
    [addphotoButton setFrame:CGRectMake(addphotoButton_x, addphotoButton_y, addphotoButton_width, addphotoButton_height)];
//    [self UpdateAddphotoButton];
    [addphotoButton.layer setCornerRadius:10.0];
    [self.view addSubview:addphotoButton];
    [addphotoButton addTarget:self action:@selector(Addphoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置定位条的点击按钮
    LocationTextField=[[UITextField alloc]init];
    UIButton *locationButton=[[UIButton alloc]init];
    [locationButton setImage:[UIImage imageNamed:@"icon_xdw"] forState:UIControlStateNormal];
    [locationButton setFrame:CGRectMake(0, 0, 30, 30)];
    [locationButton addTarget:self action:@selector(LocationAction:) forControlEvents:UIControlEventTouchUpInside];
    LocationTextField.leftView=locationButton;
    LocationTextField.leftViewMode=UITextFieldViewModeAlways;
    [LocationTextField setBackgroundColor:[UIColor lightGrayColor]];
    [LocationTextField setText:@" "];
    CGFloat LocationText_y=CGRectGetMaxY(self.FeelTextView.frame)+3;
    LocationTextField.font = [UIFont systemFontOfSize:20];
    
    [LocationTextField setFrame:CGRectMake(8, LocationText_y+44, 30, 26)];
   
    
    [LocationTextField.layer setCornerRadius:5.0];
    
    [self.view addSubview:LocationTextField];
    
    //定义用退出按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancleView) forControlEvents:UIControlEventTouchDown];
    //backButton.layer.borderWidth=2;
   // backButton.layer.borderColor=[UIColor whiteColor].CGColor;
    backButton.layer.cornerRadius = CGRectGetHeight(backButton.bounds) / 2;
   // backButton.clipsToBounds = YES;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=bu;
    //定义保存按钮
    UIButton *saveButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [saveButton setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(SaveData) forControlEvents:UIControlEventTouchDown];
    //saveButton.layer.borderWidth=2;
    //saveButton.layer.borderColor=[UIColor whiteColor].CGColor;
    saveButton.layer.cornerRadius = CGRectGetHeight(saveButton.bounds) / 2;
   // saveButton.clipsToBounds = YES;
    UIBarButtonItem *buOther=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem=buOther;
    
    
    
    [self.view bringSubviewToFront:hub];
    wordlabel =[[UILabel alloc]init];
    wordlabel.font = [UIFont systemFontOfSize:15];
    [wordlabel setText:@"800"];
    
    
     CGSize wordlabel_size = [wordlabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGFloat wordlel_x=CGRectGetMaxX(self.FeelTextView.frame)-wordlabel_size.width;
    CGFloat wordlel_y=CGRectGetMaxY(self.FeelTextView.frame)-20;
    [wordlabel setFrame:CGRectMake(wordlel_x, wordlel_y, wordlabel_size.width, 20)];
    [self.view addSubview:wordlabel];
    
    // Do any additional setup after loading the view.
}
//点击退出按钮退出添加心情视图
-(void)cancleView
{
     [self.navigationController popToRootViewControllerAnimated:YES];
}
//点击保存按钮保存数据
-(void)SaveData
{
    NSArray *temparray = [self.belongName componentsSeparatedByString:@"+"];
    NSLog(@"%@",temparray);
    NSString *str=[NSString stringWithFormat:@"%@+%@",temparray[0],temparray[1]];
    NSString *str1=[NSString stringWithFormat:@"%@+%@",temparray[1],temparray[0]];
    NSMutableArray *checkarray=[NSMutableArray array];
    [checkarray addObject:str];
    [checkarray addObject:str1];
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Timers"];
    
    [bquery whereKey:@"belongName" containedIn:checkarray];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            NSLog(@"用户不存在");
            [self save];
        }else{
            //得到属于情侣双方发表的数据
            //判断本次发表的内容与属于情路双方的曾经的内容中是否有相同 若有则不允许发布 若没有则可以发布
            for (BmobObject *obj in array) {
                
                NSString *str=[obj objectForKey:@"feelContent"];
                if ([self.FeelTextView.text isEqualToString:str]) {
                    same=YES;
                }
            }
            //执行保存操作
            [self save];
        }
    }];
}
-(void)save
{
    //先判断此次希望发表内容是否与情路双方曾经发布的内容相同
    if (same) {
        [self.view makeToast:@"说点不一样的吧0.0" duration:2 position:@"CSToastPositionCenter"];
        same=NO;
    }else{
    //保存数据
            [hub show:YES];
            BmobObject *OBJ = [BmobObject objectWithClassName:@"Timers"];
            [OBJ setObject:self.FeelTextView.text forKey:@"feelContent"];
            [OBJ setObject:LocationTextField.text forKey:@"Address"];
            [OBJ setObject:self.belongName forKey:@"belongName"];
            [OBJ saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
                if (self.imageArray.count!=0) {
                    for (int i=0; i<self.imageArray.count; i++) {
        
        
                    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Timers"];
        
                    [bquery whereKey:@"belongName" equalTo:self.belongName];
        
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
                        NSMutableArray *dataArray=[NSMutableArray array];
                        for (BmobObject *obj in array) {
                            if ([[obj objectForKey:@"feelContent"]isEqualToString:self.FeelTextView.text]) {
                                [dataArray addObject:obj];
                            }
                        }
        
                        for (BmobObject *obj in dataArray) {
                            NSData *date=UIImageJPEGRepresentation(self.imageArray[i], 1.0);
                            BmobObject *imageOBJ = [BmobObject objectWithClassName:@"Image"];
                            BmobFile *file1 = [[BmobFile alloc] initWithFileName:@"121.png" withFileData:date];
        
                            [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
                                //如果文件保存成功，则把文件添加到filetype列
                                if (isSuccessful) {
                                    [hub show:NO];
                                    [imageOBJ setObject:file1  forKey:@"Image"];
                                    [imageOBJ setObject:obj.objectId forKey:@"owner"];
                                    [imageOBJ saveInBackground];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                    [self.delegate upDate];
        
                                }else{
                                    //进行处理
                                }
                            }];
                        }
                    }];
                    }
                }else{
                    [hub show:NO];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.delegate upDate];
                }
            }];
    }
}
//开启定位后实时执行
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location=[locations lastObject];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark=[placemarks lastObject];
        
        LocationTextField.text=placemark.locality;
        NSLog(@"%@",LocationTextField.text);
        [UIView animateWithDuration:0.7 delay:0 options:0 animations:^(){
            [self updateLocationTextField];
        } completion:^(BOOL finished)
        {
        }];
    }];
}
//定位后更新LocationTextField内容并且重新设置Frame

-(void)updateLocationTextField
{
    CGFloat LocationText_y=CGRectGetMaxY(self.FeelTextView.frame)+3;
    LocationTextField.font = [UIFont systemFontOfSize:20];
    CGSize LocationTextField_size = [LocationTextField.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [LocationTextField setFrame:CGRectMake(8, LocationText_y, LocationTextField_size.width+35, LocationTextField_size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击添加图片按钮
- (IBAction)Addphoto:(id)sender {
    __block NSUInteger sourceType=0;
    //判断是否已经添加9张图片
    if (self.imageArray.count>=9) {
        //弹出只能上传九张图片的提示
        [self.view makeToast:@"一次只能上传九张图片" duration:2 position:@"CSToastPositionCenter"];
    }else{
      
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
}
//调用相册或者相机的方法
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
//获取图片
//在相册中选择图片点击choose触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [self.imageArray addObject:[editingInfo objectForKey:UIImagePickerControllerOriginalImage]];
    //模态视图退出
    [self dismissViewControllerAnimated:YES completion:nil];
    //给imageView设置图片
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView setImage:self.imageArray[i]];
        int row=i/4+1;
        int arr=i%4+1;
        //设置放置图片的View的Frame
        CGFloat imageView_width=(winWidth-50)/4;
        //设置图片的Frame
        CGFloat imageView_height=imageView_width;
        CGFloat imageView_y=44+10*row+imageView_height*(row-1);
         CGFloat imageView_x=imageView_width*(arr-1)+10*arr;
        [imageView setFrame:CGRectMake(imageView_x, imageView_y, imageView_width, imageView_height)];
        [View addSubview:imageView];
    }
}

//点击cancle触发
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //模态视图退出
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击定位button时执行
- (IBAction)LocationAction:(id)sender {
    
    //1,创建定位管理器
    locationmanager=[[CLLocationManager alloc]init];
    //2.设置代理 返回位置信息
    locationmanager.delegate=self;
    //定位的频率
    locationmanager.distanceFilter=20;
    //定位的精度
    locationmanager.desiredAccuracy=kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>8.0) {
        [locationmanager requestAlwaysAuthorization];
    }
    //开始更新
    [locationmanager startUpdatingLocation];
}
@end
