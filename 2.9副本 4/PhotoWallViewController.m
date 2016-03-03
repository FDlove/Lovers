//
//  PhotoWallViewController.m
//  Lovers
//
//  Created by student on 16/1/21.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "PhotoWallViewController.h"
#import "ClickImage.h"
#import "UIImage+WebP.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface PhotoWallViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UIView *ImageBackView;
    MBProgressHUD *hub;
}


@end

@implementation PhotoWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    hub =[[MBProgressHUD alloc]initWithView:self.view];
    hub.delegate=self;
    hub.labelText=@"正在加载请稍后...";
    [self.view addSubview:hub];
    
    NSLog(@"%@",self.ImageArray);
    self.ImageDataArray =[NSMutableArray array];
    for (int i=0;i<self.ImageArray.count;i++) {
        if ([self.ImageArray[i] isKindOfClass:[UIImage class]]) {
            self.ImageDataArray =[self.ImageArray mutableCopy];
        }else{

            [hub show:YES];
            UIImageView *ima=[[UIImageView alloc]init];
            
            [ima sd_setImageWithURL:self.ImageArray[i] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.ImageDataArray addObject:ima.image];
                [hub hide:YES];
                [self reloadInputViews];
            }];
            

    }
        
    }
    
    ImageBackView=[[UIView alloc]init];
    [self.view addSubview:ImageBackView];
    
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
    [self loadImageDate];
    
    //定义用退出按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchDown];
    backButton.layer.cornerRadius = CGRectGetHeight(backButton.bounds) / 2;
    UIBarButtonItem *bu=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=bu;
    
    // Do any additional setup after loading the view.
}
-(void)SaveData
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate UpImageWallData:self.ImageDataArray];
   
}
-(void)loadImageDate
{
    if (self.ImageDataArray.count==0) {
        UIButton *AddPhotoButton=[[UIButton alloc]init];
        [AddPhotoButton setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [AddPhotoButton addTarget:self action:@selector(Addphoto) forControlEvents:UIControlEventTouchDown];
        [AddPhotoButton setFrame:CGRectMake(10, 10,(winWidth-40)/3 ,(winWidth-40)/3 )];
        [ImageBackView addSubview:AddPhotoButton];
        [ImageBackView setFrame:CGRectMake(0, 0, winWidth, winHeight)];
        
    }else{
    //创建放图片的View
    CGFloat imageView_width=(winWidth-40)/3;
    CGFloat imageView_height=imageView_width;
    for (int i=0; i<self.ImageDataArray.count+1; i++) {
        int row=i/3+1;
        int arr=i%3+1;
        CGFloat imageView_y=10*row+imageView_height*(row-1);
        CGFloat imageView_x=imageView_width*(arr-1)+10*arr;

        if(i==self.ImageDataArray.count){
            UIButton *AddPhotoButton=[[UIButton alloc]init];
            [AddPhotoButton setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [AddPhotoButton addTarget:self action:@selector(Addphoto) forControlEvents:UIControlEventTouchDown];
            [AddPhotoButton setFrame:CGRectMake(imageView_x, imageView_y,imageView_width ,imageView_height )];
            [ImageBackView addSubview:AddPhotoButton];
        }else{
            //看是否是image类型
            if([self.ImageDataArray[i] isKindOfClass:[UIImage class]]){
                
                
                ClickImage *imageView=[[ClickImage alloc]init];
                imageView.canClick=YES;
                [imageView  setImage:self.ImageDataArray[i]];
                [imageView setFrame:CGRectMake(imageView_x, imageView_y,imageView_width ,imageView_height )];
                [ImageBackView addSubview:imageView];
                UIButton *button =[[UIButton alloc]init];
                [button setBackgroundImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(0, 0, 20, 20)];
                [NSString stringWithFormat:@"CancleAction%d",i];
                button.tag = i;
                [button addTarget:self action:@selector(CancleAction:) forControlEvents:UIControlEventTouchDown];
                [imageView addSubview: button];

                
            }
        }
    }
    
    
    [ImageBackView setFrame:CGRectMake(0, 0, winWidth, imageView_height*3+40)];
    }
    
}

-(void)backView
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击添加图片按钮
-(void)Addphoto
{

        __block NSUInteger sourceType=0;
        //判断是否已经添加9张图片
        if (self.ImageDataArray.count>=9) {
            //弹出只能上传九张图片的提示
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
    
    //模态视图退出
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.ImageDataArray addObject:[editingInfo objectForKey:UIImagePickerControllerOriginalImage]];
    //刷新视图
    [self loadImageDate];
}

//相册中点击cancle触发
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //模态视图退出
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)CancleAction:(UIButton *)btn
{
    NSLog(@"%li",btn.tag);
    [self.ImageDataArray removeObjectAtIndex:btn.tag];
    
    for (id tempView in ImageBackView.subviews) {
        [tempView removeFromSuperview];
    }
    [self loadImageDate];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%li",indexPath.row);
//    
//}
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return  self.ImageArray.count+2;
//}
//
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
//    if (indexPath.row==0) {
//        ClickImage *image=[[ClickImage alloc]initWithFrame:CGRectMake(0, 0, self.CollectionView.frame.size.height-20, self.CollectionView.frame.size.height-20)];
//        [image setBackgroundColor:[UIColor lightGrayColor]];
//        [cell addSubview:image];
//    }
//    if(indexPath.row==self.ImageArray.count+1)
//    {
//        ClickImage *image=[[ClickImage alloc]initWithFrame:CGRectMake(0, 0, self.CollectionView.frame.size.height-20, self.CollectionView.frame.size.height-20)];
//        [image setBackgroundColor:[UIColor lightGrayColor]];
//        [cell addSubview:image];
//    }
//    if (indexPath.row<=self.ImageArray.count&&indexPath.row>0) {
//    ClickImage *image=[[ClickImage alloc]initWithFrame:CGRectMake(0, 0, self.CollectionView.frame.size.height-20, self.CollectionView.frame.size.height-20)];
//    [image sd_setImageWithURL:[NSURL URLWithString:self.ImageArray[indexPath.row-1]]];
//    [cell addSubview:image];
//    }
//    return  cell;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    return CGSizeMake(120,120);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
